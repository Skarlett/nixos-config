{config, lib, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
        # Spawns process outside of shell access
        function spawn
          $argv > /dev/null 2>&1 &
          disown
        end

        export MANPAGER="less -R --use-color -Dd+r -Du+b"
    '';

    shellAliases =
    {
        ip="grc ip --color=auto";
        ping="grc ping";
        traceroute="grc traceroute";
        dig="grc dig";
        tcpdump="grc tcpdump";
        whois="grc whois";
        sysctl="grc sysctl";
        netstat="grc netstat";
        ps="grc ps";
        uptime="grc uptime";
        pv="grc pv";
        ss="grc ss";
        df="grc df";
        findmnt="grc findmnt";
        lsblk="grc lsblk";
        ls="lsd --color always";

        l="ls -la";
        la="ls -a";
        lt="ls -tree";
        gr="git reset --soft HEAD~1";
        glog="git log --graph \
                 --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' \
                 --abbrev-commit \
                 --date=relative";
        gd="git diff --color | sed 's/^\([^-+ ]*\)[-+ ]/\\1/' | less -r";
        clr="clear";
        cls="clear";
        cp="cp -r";
        tmux = "tmux -u";
        clipboard="xclip -selection c";
        more = "less";
        cat = "bat";
        ".." = "cd ..";
        "..." = "cd ../..";
        vol = "pactl -- set-sink-volume 0";
        dmesg="dmesg --color=always";
    };
  };
}
