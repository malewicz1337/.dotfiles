function copy_commandline_to_clipboard
    commandline --current-buffer | pbcopy
    commandline --function repaint
end
