<?php

namespace Las\Frontend\Controllers;

use Las\Models\Clients;

/**
 * Frontend Client Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class ClientController extends IndexController
{

    /**
     * Index Action
     *
     * @package     las
     * @version     1.0
     */
    public function temporarilyAction()
    {
        $params = $this->router->getParams();

        if (isset($params[0]) && $id = $params[0]) {
            $ip = \Las\Library\Info::ip();
            if ($device = Devices::findFirst(['IP = :ip:', 'bind' => ['ip' => ip2long($ip)]])) {
                $client = $device->getClient();
                
                if ($client->id == $id && $client->status == Clients::INDEBTED) {
                    $client->status = Clients::ACTIVE;
                    $client->save();
                }
            }
            $this->response->redirect(NULL);
        }
    }
}