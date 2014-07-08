<?php

namespace Las\Library;

use Las\Models\Clients;
use Las\Models\Devices;
use Las\Models\Messages;
use Las\Models\Networks;
use Las\Models\Redirects;
use Las\Models\Services;
use Las\Models\Settings;
use Las\Models\Tariffs;

/**
 * Las Library
 *
 * @package     las
 * @category    Library
 * @version     1.0
 */
class Las
{

    /**
     * Compile firewall code
     *
     * @package     las
     * @version     1.0
     *
     * @param string $code input firewall code
     * @param mixed $name name to save file
     * @param boolean $eval if true parse php code
     */
    public static function compile($code, $name = null, $eval = false)
    {
        $compiler = new \Phalcon\Mvc\View\Engine\Volt\Compiler();
        $compiler->addExtension(new \Las\Extension\VoltStaticFunctions());
        $compiler->addExtension(new \Las\Extension\VoltPHPFunctions());
        $php = $compiler->compileString($code);

        if ($name) {
            $dir = ROOT_PATH . '/app/common/cache/volt/app/cli/views/';
            if (!is_dir($dir)) {
                $old = umask(0);
                mkdir($dir, 0777, true);
                umask($old);
            }
            file_put_contents($dir . $name . '.phtml', $php);
        }

        return $eval ? eval('; ?>' . $php) : $php;
    }

    /**
     * Display firewall code
     *
     * @package     las
     * @version     1.0
     */
    public static function display($path, $vars = [])
    {
        $di = \Phalcon\DI::getDefault();

        if ($di->getShared('router')->getModuleName() == 'cli') {
            $view = $di->getShared('view');
        } else {
            $view = new \Phalcon\Mvc\View();
            $view->setDI($di);
            $view->registerEngines(\Las\Library\Tool::registerEngines($view, $di));
        }

        $settings = json_decode(json_encode(\Las\Library\Arr::from_model(Settings::find('status=' . Settings::ACTIVE), 'name', 'value')));
        $lans = Networks::find('status = ' . Networks::ACTIVE . ' AND type = ' . Networks::LAN);
        $wans = Networks::find('status = ' . Networks::ACTIVE . ' AND type = ' . Networks::WAN);
        $vars = [
            'clients' => Clients::find(),
            'devices' => Devices::find('status=' . Devices::ACTIVE),
            'messages' => Messages::find('status=' . Messages::ACTIVE),
            'tariffs' => Tariffs::find('status=' . Tariffs::ACTIVE),
            'settings' => $settings,
            'redirects' => Redirects::find('status=' . Redirects::ACTIVE),
            'services' => Services::find('status=' . Services::ACTIVE . ' AND client_id=0 AND device_id=0'),
            'lans' => $lans,
            'lan' => $lans->getFirst(),
            'wans' => $wans,
            'wan' => $wans->getFirst(),
            'ipt' => $settings->iptables,
            'tc' => $settings->tc,
            'EOL' => PHP_EOL,
        ];

        $view->setViewsDir(ROOT_PATH . '/app/common/cache/volt/app/cli/views/');
        ob_start();
        $view->partial($path, $vars);

        return preg_replace(['/^\s+|^[\t\s]*\n+/m', "/\x0D/"], '', ob_get_clean());
        //return preg_replace('/^\s+|^[\t\s]*\n+/m', "/\x0D/"], '', $view->partial($path, $vars, false));
    }

    public static function cmd($str, $root = false)
    {
        $las = \Las\Library\Arr::from_model(Settings::find(array('status = ' . Settings::ACTIVE)), 'category', array('name' => 'value'));

        if ($root) {
            $crypt = \Phalcon\DI::getDefault()->getShared('crypt');
            exec('echo ' . $crypt->decryptBase64($las['general']['rootPassword']) . ' | su -c ' . '"' . $str . '"', $results);
        } else {
            exec($str, $results);
        }

        if ($las['general']['debugCmd']) {
            $results = Dump::one($results, 'output');
            $results .= Dump::one($str, 'commands');
        }
        return $results;
    }

    /**
     * Filters the model's resultset
     *
     * @package     las
     * @version     1.0
     *
     * @param string $attribute model, attribute
     * @param string $operator comparison operator
     * @param mixed $value filter to this value
     * @return anonymous functions
     */
    public static function filter($attribute, $operator, $value)
    {
        return function($result) use($attribute, $operator, $value) {

            switch ($operator) {
                case '!=':
                case '<>':
                    if ($result->$attribute != $value) {
                        return $result;
                    }
                    break;
                case '>':
                    if ($result->$attribute > $value) {
                        return $result;
                    }
                    break;
                case '>=':
                    if ($result->$attribute >= $value) {
                        return $result;
                    }
                    break;
                case '<':
                    if ($result->$attribute < $value) {
                        return $result;
                    }
                    break;
                case '<=':
                    if ($result->$attribute <= $value) {
                        return $result;
                    }
                    break;
                case '!==':
                    if ($result->$attribute !== $value) {
                        return $result;
                    }
                    break;
                case '===':
                    if ($result->$attribute === $value) {
                        return $result;
                    }
                    break;
                case 'in':
                    if (in_array($result->$attribute, $value)) {
                        return $result;
                    }
                    break;
                case '!in':
                    if (!in_array($result->$attribute, $value)) {
                        return $result;
                    }
                    break;
                default:
                    if ($result->$attribute == $value) {
                        return $result;
                    }
            }
        };
    }

    public static function version()
    {
        $config = new \Phalcon\Config\Adapter\Ini(ROOT_PATH . '/app/common/config/las.ini');

        $result = $config->version->major . '.' . $config->version->minor . " ";
        switch ($config->version->special) {
            case 1:
                $suffix = "ALPHA " . $config->version->specialNumber;
                break;
            case 2:
                $suffix = "BETA " . $config->version->specialNumber;
                break;
            case 3:
                $suffix = "RC " . $config->version->specialNumber;
                break;
            default:
                $suffix = "";
                break;
        }

        $result .= $suffix;
        return trim($result);
    }

    /**
     * Get the version id
     * ABBCD
     *
     * A - Major version
     * B - Med version (two digits)
     * C - Special release: 1 = Alpha, 2 = Beta, 3 = RC, 4 = Stable
     * D - Special release version i.e. RC1, Beta2 etc.
     */
    public static function versionId()
    {
        $config = new \Phalcon\Config\Adapter\Ini(ROOT_PATH . '/app/common/config/las.ini');
        return $config->version->major . sprintf("%02s", $config->version->minor) . $config->version->special . $config->version->specialNumber;
    }

}
