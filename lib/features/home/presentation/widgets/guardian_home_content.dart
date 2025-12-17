import 'package:flutter/material.dart';

/// 보호자 홈 컨텐츠
///
/// Scenario C 영역: 보호자 전용 기능
class GuardianHomeContent extends StatelessWidget {
  const GuardianHomeContent({
    super.key,
    this.displayName,
    required this.canAccessGuardianFeatures,
  });

  final String? displayName;
  final bool canAccessGuardianFeatures;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 환영 메시지
          _buildWelcomeSection(context),
          const SizedBox(height: 24),

          // 피보호자 관리 섹션 (권한 있을 때만)
          if (canAccessGuardianFeatures) ...[
            _buildWardManagementSection(context),
            const SizedBox(height: 24),
          ],

          // 알림 센터 섹션
          _buildNotificationSection(context),
          const SizedBox(height: 24),

          // 퀵 액션 섹션
          _buildQuickActionsSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.family_restroom,
                size: 30,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, ${displayName ?? '보호자'}님!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '소중한 가족의 건강을 함께 관리해요 🏠',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWardManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '피보호자 관리',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: 피보호자 추가 페이지로 이동
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('추가'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 피보호자 목록 (Mock 데이터)
        Card(
          child: Column(
            children: [
              _buildWardTile(
                context,
                name: '홍길동',
                relation: '부모님',
                lastUpdate: '오늘 오전 10:30',
                status: WardStatus.normal,
              ),
              const Divider(height: 1),
              _buildWardTile(
                context,
                name: '김영희',
                relation: '배우자',
                lastUpdate: '어제',
                status: WardStatus.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWardTile(
    BuildContext context, {
    required String name,
    required String relation,
    required String lastUpdate,
    required WardStatus status,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(status).withValues(alpha: 0.2),
        child: Icon(Icons.person, color: _getStatusColor(status)),
      ),
      title: Text(name),
      subtitle: Text('$relation • 최근 업데이트: $lastUpdate'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusText(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        // TODO: 피보호자 상세 페이지로 이동
      },
    );
  }

  Color _getStatusColor(WardStatus status) {
    switch (status) {
      case WardStatus.normal:
        return Colors.green;
      case WardStatus.warning:
        return Colors.orange;
      case WardStatus.danger:
        return Colors.red;
    }
  }

  String _getStatusText(WardStatus status) {
    switch (status) {
      case WardStatus.normal:
        return '정상';
      case WardStatus.warning:
        return '주의';
      case WardStatus.danger:
        return '위험';
    }
  }

  Widget _buildNotificationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 알림',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildNotificationItem(
                  context,
                  icon: Icons.notifications_active,
                  title: '홍길동님 혈압 측정 알림',
                  time: '10분 전',
                  isNew: true,
                ),
                const Divider(),
                _buildNotificationItem(
                  context,
                  icon: Icons.check_circle_outline,
                  title: '김영희님 약 복용 완료',
                  time: '1시간 전',
                  isNew: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String time,
    required bool isNew,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isNew
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isNew)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '빠른 액션',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildActionTile(
                context,
                icon: Icons.phone_outlined,
                title: '응급 연락처',
                onTap: () {
                  // TODO: 응급 연락처 페이지로 이동
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                context,
                icon: Icons.article_outlined,
                title: '보호자 가이드',
                onTap: () {
                  // TODO: 보호자 가이드 페이지로 이동
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// 피보호자 상태
enum WardStatus { normal, warning, danger }
