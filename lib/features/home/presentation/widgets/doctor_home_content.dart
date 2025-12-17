import 'package:flutter/material.dart';

/// 의료진 홈 컨텐츠
///
/// Scenario C 영역: 의료진 전용 기능
class DoctorHomeContent extends StatelessWidget {
  const DoctorHomeContent({
    super.key,
    this.displayName,
    required this.canManagePatients,
  });

  final String? displayName;
  final bool canManagePatients;

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

          // 환자 관리 섹션 (권한 있을 때만)
          if (canManagePatients) ...[
            _buildPatientManagementSection(context),
            const SizedBox(height: 24),
          ],

          // 오늘의 일정 섹션
          _buildScheduleSection(context),
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
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              child: Icon(
                Icons.medical_services,
                size: 30,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, ${displayName ?? '선생'}님!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '오늘도 환자분들의 건강을 위해 힘써주세요 🏥',
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

  Widget _buildPatientManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '담당 환자',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: 전체 환자 목록 페이지로 이동
              },
              child: const Text('전체 보기'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 환자 통계 카드
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.people_outline,
                value: '24',
                label: '총 환자',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.warning_amber_outlined,
                value: '3',
                label: '주의 필요',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                icon: Icons.check_circle_outline,
                value: '21',
                label: '양호',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 최근 알림이 있는 환자
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('박환자'),
                subtitle: const Text('혈압 상승 경고 • 10분 전'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 환자 상세 페이지로 이동
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(Icons.person, color: Colors.green.shade700),
                ),
                title: const Text('이환자'),
                subtitle: const Text('정기 검진 완료 • 1시간 전'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 환자 상세 페이지로 이동
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘의 일정',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildScheduleItem(
                context,
                time: '09:00',
                title: '박환자 정기 검진',
                isCompleted: true,
              ),
              const Divider(height: 1),
              _buildScheduleItem(
                context,
                time: '10:30',
                title: '이환자 상담',
                isCompleted: true,
              ),
              const Divider(height: 1),
              _buildScheduleItem(
                context,
                time: '14:00',
                title: '김환자 검사 결과 상담',
                isCompleted: false,
                isCurrent: true,
              ),
              const Divider(height: 1),
              _buildScheduleItem(
                context,
                time: '16:00',
                title: '최환자 정기 검진',
                isCompleted: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String time,
    required String title,
    required bool isCompleted,
    bool isCurrent = false,
  }) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : null,
        ),
      ),
      trailing: isCompleted
          ? Icon(Icons.check_circle, color: Colors.green.shade400)
          : isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '진행중',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : const Icon(Icons.circle_outlined, size: 20),
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
                icon: Icons.person_add_outlined,
                title: '새 환자 등록',
                onTap: () {
                  // TODO: 환자 등록 페이지로 이동
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                context,
                icon: Icons.analytics_outlined,
                title: '통계 및 리포트',
                onTap: () {
                  // TODO: 통계 페이지로 이동
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                context,
                icon: Icons.article_outlined,
                title: '의료 가이드라인',
                onTap: () {
                  // TODO: 가이드라인 페이지로 이동
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
