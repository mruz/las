<?php

namespace Las\Library;

/**
 * Info Library
 *
 * @package     las
 * @category    Library
 * @version     1.0
 */
class Info
{

    public static function hostname()
    {
        if ($hostname = Info::proc('sys/kernel/hostname')) {
            return $hostname;
        } else {
            return null;
        }
    }

    public static function ip()
    {
        $client = @$_SERVER['HTTP_CLIENT_IP'];
        $forward = @$_SERVER['HTTP_X_FORWARDED_FOR'];
        $remote = $_SERVER['REMOTE_ADDR'];

        if (filter_var($client, FILTER_VALIDATE_IP)) {
            $ip = $client;
        } elseif (filter_var($forward, FILTER_VALIDATE_IP)) {
            $ip = $forward;
        } else {
            $ip = $remote;
        }
        return $ip;
    }

    public static function loadavg()
    {
        if ($loadavg = Info::proc('loadavg')) {
            $result = preg_split("/\s/", $loadavg, 4);
            unset($result[3]);
            return implode(' ', $result);
        } else {
            return null;
        }
    }

    public static function mac($ip)
    {
        $mac = shell_exec('arp -an ' . $ip);
        preg_match('/..:..:..:..:..:../', $mac, $matches);
        $mac = @$matches[0];

        return $mac;
    }

    public static function ping($ip, $count = 2)
    {
        $received = shell_exec('ping ' . $ip . " -c " . $count . " -W 1 -i 0.2 -l 2 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }'");
        return $received;
    }

    public static function proc($file)
    {
        if (PHP_OS == "Linux" && $return = @file_get_contents('/proc/' . $file)) {
            return $return;
        }
    }

    public static function release()
    {
        if (!$release = @parse_ini_file("/etc/os-release", true)) {
            if (!$release = @parse_ini_file("/etc/lsb-release", true)) {
                $content = preg_replace('/^[^=]*\n/m', '', @shell_exec('cat /etc/*-release'));
                $release = @parse_ini_string($content, true);
            }
        }
        return $release;
    }

    public static function uptime()
    {
        if ($uptime = Info::proc('uptime')) {
            $days = floor($uptime / 60 / 60 / 24);
            $hours = $uptime / 60 / 60 % 24;
            $mins = $uptime / 60 % 60;
            $secs = $uptime % 60;
            $time = '';
            if ($days > 0) {
                $time .= __(':days days', [':days' => $days]) . ' ';
            }
            if ($hours > 0) {
                $time .= __(':hours hours', [':hours' => $hours]) . ' ';
            }
            if ($mins > 0) {
                $time .= __(':mins mins', [':mins' => $mins]) . ' ';
            }
            if ($secs > 0) {
                $time .= __(':secs secs', [':secs' => $secs]);
            }
            return $time;
        } else {
            return null;
        }
    }

}
