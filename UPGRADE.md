# Jekyll Upgrade Guide from v4.3.4 to v4.4.1

## Summary of Changes
- Bug Fix: Restore globbed path behavior in front matter defaults (as noted in v4.4.1)

## Recommended Upgrade Steps
1. Update your Gemfile to use `gem 'jekyll', '~> 4.4.1'`
2. Run `bundle update jekyll`
3. Review any configuration using globbed paths in `_config.yml`
4. Test locally to ensure site builds correctly

## Changelog Reference
- v4.4.1 (2025-01-29): https://github.com/jekyll/jekyll/releases/tag/v4.4.1
- v4.4.0 (2024-12-15): https://github.com/jekyll/jekyll/releases/tag/v4.4.0
- v4.3.4 (2024-11-02): https://github.com/jekyll/jekyll/releases/tag/v4.3.4