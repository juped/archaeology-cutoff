/-  gh
|%
++  repository
  ^-  $+(json (unit repository:gh))
  =+  jo
  %-  ot  :~
      'id'^id
      'name'^so
      'full_name'^so
      'owner'^user
      'private'^bo
      'html_url'^so
      'description'^so
      'fork'^bo
      'url'^so
      'forks_url'^so
      'keys_url'^so
      'collaborators_url'^so
      'teams_url'^so
      'hooks_url'^so
      'issue_events_url'^so
      'events_url'^so
      'assignees_url'^so
      'branches_url'^so
      'tags_url'^so
      'blobs_url'^so
      'git_tags_url'^so
      'git_refs_url'^so
      'trees_url'^so
      'statuses_url'^so
      'languages_url'^so
      'stargazers_url'^so
      'contributors_url'^so
      'subscribers_url'^so
      'subscription_url'^so
      'commits_url'^so
      'git_commits_url'^so
      'comments_url'^so
      'issue_comment_url'^so
      'contents_url'^so
      'compare_url'^so
      'merges_url'^so
      'archive_url'^so
      'downloads_url'^so
      'issues_url'^so
      'pulls_url'^so
      'milestones_url'^so
      'notifications_url'^so
      'labels_url'^so
      'releases_url'^so
      'created_at'^so
      'updated_at'^so
      'pushed_at'^so
      'git_url'^so
      'ssh_url'^so
      'clone_url'^so
      'svn_url'^so
      'homepage'^some
      'size'^ni
      'stargazers_count'^ni
      'watchers_count'^ni
      'language'^some
      'has_issues'^bo
      'has_downloads'^bo
      'has_wiki'^bo
      'has_pages'^bo
      'forks_count'^ni
      'mirror_url'^some
      'open_issues_count'^ni
      'forks'^ni
      'open_issues'^ni
      'watchers'^ni
      'default_branch'^so
  ==
++  user
  ^-  $+(json (unit user:gh))
  =+  jo
  %-  ot  :~
      'login'^so
      'id'^id
      'avatar_url'^so
      'gravatar_id'^so
      'url'^so
      'html_url'^so
      'followers_url'^so
      'following_url'^so
      'gists_url'^so
      'starred_url'^so
      'subscriptions_url'^so
      'organizations_url'^so
      'repos_url'^so
      'events_url'^so
      'received_events_url'^so
      'type'^so
      'site_admin'^bo
  ==
++  issue
  ^-  $+(json (unit issue:gh))
  =+  jo
  %-  ot  :~
      'url'^so
      'labels_url'^so
      'comments_url'^so
      'events_url'^so
      'html_url'^so
      'id'^id
      'number'^ni
      'title'^so
      'user'^user::|+(* (some *user:gh))
      'labels'^(ar label)::|+(* (some *(list label:gh)))::(ar label)
      'state'^so
      'locked'^bo
      'assignee'^(mu user)::|+(* (some *(unit user:gh)))::(mu user)
      'milestone'^some
      'comments'^ni
      'created_at'^so
      'updated_at'^so
      'closed_at'^(mu so)
      'body'^so
  ==
++  label
  ^-  $+(json (unit label:gh))
  =+  jo
  %-  ot  :~
      'url'^so
      'name'^so
      'color'^so
  ==
++  comment
  ^-  $+(json (unit comment:gh))
  =+  jo
  %-  ot  :~
      'url'^so
      'html_url'^so
      'issue_url'^so
      'id'^id
      'user'^user
      'created_at'^so
      'updated_at'^so
      'body'^so
  ==
++  id  no:jo
--
