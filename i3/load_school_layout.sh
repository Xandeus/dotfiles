#!/bin/bash
i3-msg "workspace 1; append_layout ~/.config/i3/workspace_school_1.json"
(firefox http://calendar.google.com/ https://mail.google.com/mail/u/0/ https://mail.google.com/mail/u/1/ http://canvas.umn.edu/ &)
(urxvt &)
(urxvt &)

