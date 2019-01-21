#!/bin/bash
i3-msg "workspace 2; append_layout ~/.config/i3/workspace_work_2.json"
(pycharm &)
i3-msg "workspace 1; append_layout ~/.config/i3/workspace_work_1.json"
(firefox https://mail.google.com/mail/u/0/ https://mail.google.com/mail/u/1/ https://monaminkara.com/ https://github.umn.edu/ https://minkinc.slack.com/ &)
(urxvt &)
(urxvt &)

