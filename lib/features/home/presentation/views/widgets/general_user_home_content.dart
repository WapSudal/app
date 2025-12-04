import 'package:flutter/material.dart';

/// 일반 사용자 홈 컨텐츠
///
/// Scenario A 영역: 모든 역할 공통 UI + 일반 사용자 전용 기능
class GeneralUserHomeContent extends StatelessWidget {
  const GeneralUserHomeContent({
    super.key,
    this.displayName,
    required this.canManageOwnHealth,
  });

  final String? displayName;
  final bool canManageOwnHealth;

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

          // 본인 건강 관리 섹션 (권한 있을 때만)
          if (canManageOwnHealth) ...[
            _buildHealthManagementSection(context),
            const SizedBox(height: 24),
          ],

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
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '안녕하세요, ${displayName ?? '사용자'}님!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '오늘도 건강한 하루 보내세요 💪',
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

  Widget _buildHealthManagementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 건강 관리',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHealthCard(
                context,
                icon: Icons.monitor_heart_outlined,
                title: '건강 기록',
                subtitle: '혈압, 혈당 등 기록',
                onTap: () {
                  // TODO: 건강 기록 페이지로 이동
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHealthCard(
                context,
                icon: Icons.trending_up,
                title: '건강 추이',
                subtitle: '기록 분석 보기',
                onTap: () {
                  // TODO: 건강 추이 페이지로 이동
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
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
                icon: Icons.article_outlined,
                title: '뇌졸중 예방 정보',
                onTap: () {
                  // TODO: 정보 페이지로 이동
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                context,
                icon: Icons.warning_amber_outlined,
                title: '응급 연락처',
                onTap: () {
                  // TODO: 응급 연락처 페이지로 이동
                },
              ),
              const Divider(height: 1),
              _buildActionTile(
                context,
                icon: Icons.help_outline,
                title: '자주 묻는 질문',
                onTap: () {
                  // TODO: FAQ 페이지로 이동
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
