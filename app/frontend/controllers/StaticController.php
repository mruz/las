<?php

namespace Las\Frontend\Controllers;

/**
 * Static Payment Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class StaticController extends IndexController
{

    /**
     * Contact Action
     *
     * @package     las
     * @version     1.0
     */
    public function contactAction()
    {
        $this->tag->setTitle(__('Contact'));

        if ($this->request->isPost() === true) {
            $validation = new \Las\Extension\Validation();

            $validation->add('fullName', new \Phalcon\Validation\Validator\PresenceOf());
            $validation->add('content', new \Phalcon\Validation\Validator\PresenceOf());
            $validation->add('content', new \Phalcon\Validation\Validator\StringLength(array(
                'max' => 5000,
                'min' => 10,
            )));
            $validation->add('email', new \Phalcon\Validation\Validator\PresenceOf());
            $validation->add('email', new \Phalcon\Validation\Validator\Email());
            $validation->add('repeatEmail', new \Phalcon\Validation\Validator\Confirmation(array(
                'with' => 'email',
            )));

            $validation->setLabels(array('fullName' => __('Full name'), 'content' => __('Content'), 'email' => __('Email'), 'repeatEmail' => __('Repeat email')));
            $messages = $validation->validate($_POST);

            if (count($messages)) {
                $this->view->setVar('errors', $validation->getMessages());
                $this->flashSession->warning($this->tag->linkTo(array('#', 'class' => 'close', 'title' => __("Close"), '×')) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            } else {
                $this->flashSession->notice($this->tag->linkTo(array('#', 'class' => 'close', 'title' => __("Close"), '×')) . '<strong>' . __('Success') . '!</strong> ' . __("Message was sent"));

                $email = new \Las\Library\Email();
                $email->prepare(__('Contact'), $this->config->app->admin, 'contact', array(
                    'fullName' => $this->request->getPost('fullName'),
                    'email' => $this->request->getPost('email'),
                    'content' => $this->request->getPost('content'),
                ));
                $email->addReplyTo($this->request->getPost('email'));

                if ($email->Send() === true) {
                    $_POST = [];
                } else {
                    \Las\Bootstrap::log($email->ErrorInfo);
                }
            }
        }
    }

    /**
     * Buy me some chocolate Action
     *
     * @package     las
     * @version     1.0
     */
    public function buyAction()
    {
        $this->tag->setTitle(__('Buy chocolate'));
        if ($this->request->isPost() == TRUE && $this->request->hasPost('quantity')) {
            $this->session->set('checkout', array(
                'price' => 1,
                'quantity' => $this->request->getPost('quantity'),
            ));
            
            $this->response->redirect('payment/checkout');
        }
    }

}
