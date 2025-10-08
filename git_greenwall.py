import os
import datetime
import random


def git_bulk_empty_commit(repo_path, days=365, min_commits=1, max_commits=3):
    """
    一次性提交多个带不同日期的空 commit
    :param repo_path: Git 仓库路径
    :param days: 模拟多少天的提交
    :param min_commits: 每天最少 commit 数
    :param max_commits: 每天最多 commit 数
    """
    os.chdir(repo_path)

    for day in range(days):
        commit_date = datetime.datetime.now() - datetime.timedelta(days=day)
        formatted_date = commit_date.strftime("%Y-%m-%d")

        commit_count = random.randint(min_commits, max_commits)

        for _ in range(commit_count):
            os.system(f'git commit --allow-empty --date="{formatted_date}" -m "Auto commit on {formatted_date}"')

    os.system('git push origin main')


if __name__ == "__main__":
    # 替换成你的本地 Git 仓库路径
    repo_path = "/path/to/your/git/repo"
    git_bulk_empty_commit(repo_path)