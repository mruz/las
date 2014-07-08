<?php

namespace Las\Cli\Tasks;

use Las\Library\Las;
use Las\Models\Firewalls;

/**
 * Firewall CLI Task
 *
 * @package     las
 * @category    Task
 * @version     1.0
 */
class FirewallTask extends MainTask
{

    /**
     * Main Action - display all firewalls
     *
     * @package     las
     * @version     1.0
     */
    public function mainAction()
    {
        $firewalls = Firewalls::find();
        foreach ($firewalls as $firewall) {
            echo "\t" . $firewall->id . '. ' . $firewall->name . "\n";
        }
    }

    /**
     * Compile Action - compile the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function compileAction()
    {
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst(intval($params[0]) ? $params[0] : ['name=:name:', 'bind' => ['name' => $params[0]]])) {
            Las::compile($firewall->content, $firewall->name);
        }
    }

    /**
     * Display Action - display/run the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function displayAction()
    {
        $params = $this->router->getParams();
        if (isset($params[0]) && $firewall = Firewalls::findFirst(intval($params[0]) ? $params[0] : ['name=:name:', 'bind' => ['name' => $params[0]]])) {
            echo Las::display($firewall->name);
        }
    }

}
