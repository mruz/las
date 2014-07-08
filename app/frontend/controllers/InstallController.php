<?php

namespace Las\Frontend\Controllers;

use Las\Models\Users;

/**
 * Frontend Install Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class InstallController extends IndexController
{

    /**
     * Index action - add admin user
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        // Set title, pick view and send variables
        $this->tag->setTitle(__('Install'));
        $this->view->pick('user/signup');

        // Check if the form has been sent
        if ($this->request->isPost() == TRUE) {
            $user = new Users();
            $signup = $user->signup(true);

            if ($signup instanceof Users) {
                $hash = md5($signup->id . $signup->email . $signup->password . $this->config->auth->hash_key);
                $this->response->redirect('user/activation/' . $signup->username . '/' . $hash.'/admin');
            } else {
                $this->view->setVar('errors', $signup);
                $this->flashSession->warning($this->tag->linkTo(array('#', 'class' => 'close', 'title' => __("Close"), '×')) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        }
    }

}
