<?php

namespace Las\Frontend\Controllers;

/**
 * Frontend Lang Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class LangController extends IndexController
{

    /**
     * Set language Action
     *
     * @package     las
     * @version     1.0
     */
    public function setAction()
    {
        $params = $this->router->getParams();

        if ($lang = $params[0]) {
            // Store lang in session and cookie
            $this->session->set('lang', $lang);
            $this->cookies->set('lang', $lang, time() + 365 * 86400);
        }

        // Go to the last place
        $referer = $this->request->getHTTPReferer();
        if (strpos($referer, $this->request->getHttpHost() . "/") !== false) {
            return $this->response->setHeader("Location", $referer);
        } else {
            return $this->dispatcher->forward(array('controller' => 'index', 'action' => 'index'));
        }
    }

}
