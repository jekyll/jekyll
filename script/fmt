#!/bin/bash
echo "RuboCop $(bundle exec rubocop --version)"
bundle exec rubocop -D --disable-pending-cops $@
success=$?
if ((success != 0)); then
   echo -e "\nTry running \`script/fmt -a\` to automatically fix errors"
fi
exit $success
