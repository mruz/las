<?php

namespace Las\Backend\Controllers;

use Las\Library\Info;

/**
 * Backend Ajax Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class AjaxController extends \Phalcon\Mvc\Controller
{

    /**
     * Initialize - disable render view
     *
     * @package     las
     * @version     1.0
     */
    public function initialize()
    {
        $this->view->setRenderLevel(\Phalcon\Mvc\View::LEVEL_NO_RENDER);

        if ($this->request->isPost() != true && $this->request->isAjax() != true) {
            parent::notFoundAction();
        }
    }

    /**
     * Refresh action - refresh info at admin panel
     *
     * @package     las
     * @version     1.0
     */
    public function refreshAction()
    {
        switch ($this->request->getPost('type')) {
            case 'loadavg':
                echo Info::loadavg();
                break;
            case 'time':
                echo date('Y-m-d H:i:s');
                break;
            case 'uptime':
                echo Info::uptime();
                break;
        }
    }

}
