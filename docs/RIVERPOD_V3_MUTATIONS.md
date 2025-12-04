# Riverpod 3.0 Mutations Guide

> **Status**: Experimental  
> **Purpose**: Handle UI-reactive side effects (form submissions, button clicks, etc.)  
> **Version**: Riverpod 3.0+

---

## Table of Contents

1. [What are Mutations?](#what-are-mutations)
2. [Problems Mutations Solve](#problems-mutations-solve)
3. [Defining Mutations](#defining-mutations)
4. [Mutation States](#mutation-states)
5. [Using Mutations in UI](#using-mutations-in-ui)
6. [Triggering Mutations](#triggering-mutations)
7. [Scoped Mutations](#scoped-mutations)
8. [Resetting Mutations](#resetting-mutations)
9. [Best Practices](#best-practices)
10. [Complete Examples](#complete-examples)

---

## What are Mutations?

Mutations are objects that enable the UI to react to state changes during side effects. They track the progress of operations like form submissions, providing loading, success, and error states without polluting your provider state.

**Key Benefits:**
- Display loading indicators during async operations
- Show success/error messages after completion
- Keep provider state clean from UI concerns
- Prevent provider disposal during ongoing operations

---

## Problems Mutations Solve

### 1. UI Reaction to Side Effects
Traditional approach pollutes provider state with UI concerns:

```dart
// ❌ Without Mutations - Provider state polluted with UI state
@freezed
abstract class TodoListState with _$TodoListState {
  const factory TodoListState({
    required List<Todo> todos,
    @Default(false) bool isAdding,      // UI concern
    String? addError,                    // UI concern
    Todo? lastAddedTodo,                 // UI concern
  }) = _TodoListState;
}
```

### 2. Provider Disposal During Side Effects
Using `ref.read` with auto-dispose can cause providers to be disposed while a side effect is still in progress. Mutations solve this by keeping providers alive during the operation.

---

## Defining Mutations

Mutations are instances of the `Mutation` class stored in a final variable:

```dart
import 'package:flutter_riverpod/experimental/mutation.dart';

// Global mutation
final addTodo = Mutation<Todo>();

// Or as a static field in a Notifier
@riverpod
class TodoList extends _$TodoList {
  static final addTodo = Mutation<Todo>();
  static final removeTodo = Mutation<void>();
  
  @override
  Future<List<Todo>> build() async => fetchTodos();
}
```

**Generic Type**: The generic type (`<Todo>`) specifies the return type of the mutation, enabling UI to access the result.

---

## Mutation States

Mutations have four possible states:

| State | Description | Use Case |
|-------|-------------|----------|
| `MutationIdle` | Not started or has been reset | Show submit button |
| `MutationPending` | Operation in progress | Show loading indicator |
| `MutationSuccess<T>` | Completed successfully | Show success message, access result |
| `MutationError` | Failed with error | Show error message, retry button |

### Type Checking

```dart
final state = ref.watch(addTodo);

// Pattern matching (recommended)
switch (state) {
  case MutationIdle():
    // Show submit button
  case MutationPending():
    // Show loading
  case MutationSuccess(:final value):
    // Show success, access value
  case MutationError(:final error):
    // Show error
}

// Type checking
if (state is MutationPending) {
  // Show loading
}
```

---

## Using Mutations in UI

### Basic Usage with ref.watch

```dart
class AddTodoButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addTodoState = ref.watch(addTodo);
    
    return switch (addTodoState) {
      MutationIdle() => ElevatedButton(
        onPressed: () => _handleAddTodo(ref),
        child: const Text('Add Todo'),
      ),
      MutationPending() => const CircularProgressIndicator(),
      MutationError(:final error) => ElevatedButton(
        onPressed: () => _handleAddTodo(ref),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: Text('Retry: $error'),
      ),
      MutationSuccess(:final value) => Text('Added: ${value.title}'),
    };
  }
  
  void _handleAddTodo(WidgetRef ref) {
    // See "Triggering Mutations" section
  }
}
```

### Combined State UI

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final addTodoState = ref.watch(addTodo);
  
  return Row(
    children: [
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: switch (addTodoState) {
            MutationError() => const WidgetStatePropertyAll(Colors.red),
            _ => null,
          },
        ),
        onPressed: addTodoState is MutationPending
            ? null
            : () => _handleAddTodo(ref),
        child: const Text('Add Todo'),
      ),
      if (addTodoState is MutationPending) ...[
        const SizedBox(width: 8),
        const CircularProgressIndicator(),
      ],
    ],
  );
}
```

---

## Triggering Mutations

Use `Mutation.run()` to execute a mutation:

```dart
void _handleAddTodo(WidgetRef ref) {
  addTodo.run(ref, (tsx) async {
    // tsx = MutationTransaction
    // Use tsx.get() instead of ref.read() to keep providers alive
    
    final todoNotifier = tsx.get(todoListProvider.notifier);
    final createdTodo = await todoNotifier.addTodo('New Todo');
    
    // Return value becomes MutationSuccess.value
    return createdTodo;
  });
}
```

### Critical: Use `tsx.get()` Instead of `ref.read()`

```dart
// ❌ Wrong - Provider might be disposed during async operation
addTodo.run(ref, (tsx) async {
  final notifier = ref.read(todoListProvider.notifier);
  await notifier.addTodo('Todo');
});

// ✅ Correct - Provider stays alive until mutation completes
addTodo.run(ref, (tsx) async {
  final notifier = tsx.get(todoListProvider.notifier);
  await notifier.addTodo('Todo');
});
```

---

## Scoped Mutations

For operations on specific items (like deleting a specific todo), scope mutations with a unique key:

```dart
final removeTodo = Mutation<void>();

// In your widget
class TodoItem extends ConsumerWidget {
  final Todo todo;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Scope the mutation by todo.id
    final removeState = ref.watch(removeTodo(todo.id));
    
    return ListTile(
      title: Text(todo.title),
      trailing: switch (removeState) {
        MutationPending() => const CircularProgressIndicator(),
        _ => IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _handleRemove(ref),
        ),
      },
    );
  }
  
  void _handleRemove(WidgetRef ref) {
    removeTodo(todo.id).run(ref, (tsx) async {
      await tsx.get(todoListProvider.notifier).removeTodo(todo.id);
    });
  }
}
```

### Scoped Mutations with Generic Types

```dart
final create = Mutation<ApiResponse>();

// Scope with key and specify return type
final createTodo = create<CreatedResponse<Todo>>('create_todo');

Future<void> executeCreateTodo(WidgetRef ref) async {
  await createTodo.run(ref, (tsx) async {
    final client = tsx.get(apiProvider);
    final response = await client.post('/todos', data: {'title': 'New'});
    return CreatedResponse<Todo>.fromJson(response.data, Todo.fromJson);
  });
}
```

---

## Resetting Mutations

Mutations automatically reset to `MutationIdle` when:
1. The operation completes (success or error) AND all listeners are removed
2. Similar to auto-dispose behavior

### Manual Reset

```dart
ElevatedButton(
  onPressed: () => addTodo.reset(ref),
  child: const Text('Reset'),
)
```

---

## Best Practices

### 1. Define Mutations at Appropriate Scope

```dart
// ✅ Global - For app-wide operations
final logout = Mutation<void>();

// ✅ Static on Notifier - For feature-specific operations
@riverpod
class TodoList extends _$TodoList {
  static final addTodo = Mutation<Todo>();
  static final removeTodo = Mutation<void>();
}

// ✅ Widget-level for truly local operations (rare)
```

### 2. Always Use tsx.get() in Mutation Callbacks

```dart
// ✅ Correct
addTodo.run(ref, (tsx) async {
  await tsx.get(provider.notifier).method();
});
```

### 3. Return Meaningful Values

```dart
// ✅ Return the created entity for UI feedback
final addTodo = Mutation<Todo>();

addTodo.run(ref, (tsx) async {
  final todo = await tsx.get(todoListProvider.notifier).add(title);
  return todo; // UI can show "Added: ${todo.title}"
});
```

### 4. Handle All States in UI

```dart
// ✅ Always handle all four states
switch (state) {
  case MutationIdle(): // Ready state
  case MutationPending(): // Loading state
  case MutationSuccess(): // Success state
  case MutationError(): // Error state
}
```

### 5. Use Scoped Mutations for List Operations

```dart
// ✅ Each item has its own mutation state
final deleteItem = Mutation<void>();

// In list item widget
ref.watch(deleteItem(item.id));
deleteItem(item.id).run(ref, ...);
```

---

## Complete Examples

### Form Submission Example

```dart
// mutations.dart
final submitForm = Mutation<SubmissionResult>();

// form_view.dart
class FormView extends ConsumerStatefulWidget {
  @override
  ConsumerState<FormView> createState() => _FormViewState();
}

class _FormViewState extends ConsumerState<FormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(submitForm);
    
    // Show snackbar on success or error
    ref.listen(submitForm, (previous, next) {
      if (next is MutationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );
        Navigator.pop(context);
      } else if (next is MutationError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            enabled: submitState is! MutationPending,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          switch (submitState) {
            MutationPending() => const CircularProgressIndicator(),
            _ => ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          },
        ],
      ),
    );
  }
  
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    submitForm.run(ref, (tsx) async {
      final repository = tsx.get(formRepositoryProvider);
      return await repository.submit(name: _nameController.text);
    });
  }
}
```

### Delete with Confirmation Example

```dart
final deleteItem = Mutation<void>();

class ItemCard extends ConsumerWidget {
  final Item item;
  
  const ItemCard({required this.item});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(deleteItem(item.id));
    
    return Card(
      child: ListTile(
        title: Text(item.name),
        trailing: switch (deleteState) {
          MutationPending() => const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          MutationError(:final error) => IconButton(
            icon: const Icon(Icons.error, color: Colors.red),
            tooltip: error.toString(),
            onPressed: () => _confirmDelete(context, ref),
          ),
          _ => IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref),
          ),
        },
      ),
    );
  }
  
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      deleteItem(item.id).run(ref, (tsx) async {
        await tsx.get(itemRepositoryProvider).delete(item.id);
      });
    }
  }
}
```

---

## Summary

| Aspect | Guideline |
|--------|-----------|
| Import | `package:flutter_riverpod/experimental/mutation.dart` |
| Definition | `final myMutation = Mutation<ReturnType>();` |
| Listening | `ref.watch(myMutation)` or `ref.listen(myMutation, ...)` |
| Triggering | `myMutation.run(ref, (tsx) async { ... });` |
| Provider Access | Always use `tsx.get(provider)` inside callbacks |
| Scoping | `myMutation(uniqueKey)` for item-specific operations |
| Reset | `myMutation.reset(ref)` or automatic when listeners removed |

---

## References

- [Official Documentation: Mutations](https://riverpod.dev/docs/concepts2/mutations)
- [What's New in Riverpod 3.0](https://riverpod.dev/docs/whats_new#mutations-experimental)
- [Mutation API Reference](https://pub.dev/documentation/riverpod/latest/experimental_mutation/Mutation-class.html)
