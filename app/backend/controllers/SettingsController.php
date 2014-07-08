<?php

namespace Las\Backend\Controllers;

use Las\Models\Settings;

/**
 * Backend Settings Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class SettingsController extends IndexController
{

    /**
     * General settings
     *
     * @package     las
     * @version     1.0
     */
    public function indexAction()
    {
        $this->tag->setTitle(__('Settings') . ' / ' . __('General'));
        $settings = Settings::find(['category = "general" AND status = ' . Settings::ACTIVE]);
        $this->view->setVars([
            'settings' => $settings,
            'category' => __('General'),
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            // Try to update settings
            $valid = Settings::general($settings);

            // Check if data are valid
            if ($valid === TRUE) {
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
                $_POST['rootPassword'] = $this->crypt->decryptBase64($_POST['rootPassword']);
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            $diff = [
                'rootPassword' => $this->crypt->decryptBase64($this->las['general']['rootPassword'])
            ];
            // Values to fill out the form
            $this->tag->setDefaults(array_merge($this->las['general'], $diff));
        }
    }

    /**
     * Payment settings
     *
     * @package     las
     * @version     1.0
     */
    public function paymentsAction()
    {
        $this->tag->setTitle(__('Settings') . ' / ' . __(ucfirst($this->dispatcher->getActionName())));
        $settings = Settings::find(['category = :category: AND status = :status:', 'bind' => [':category' => $this->dispatcher->getActionName(), ':status' => Settings::ACTIVE]]);
        $this->view->setVars([
            'settings' => $settings,
            'category' => __(ucfirst($this->dispatcher->getActionName()))
        ]);
        $this->view->pick('settings/index');

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            // Try to update settings
            $valid = Settings::payments($settings);

            // Check if data are valid
            if ($valid === TRUE) {
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            // Values to fill out the form
            $this->tag->setDefaults($this->las[$this->dispatcher->getActionName()]);
        }
    }

    /**
     * Qos settings
     *
     * @package     las
     * @version     1.0
     */
    public function qosAction()
    {
        $this->tag->setTitle(__('Settings') . ' / ' . __(ucfirst($this->dispatcher->getActionName())));
        $settings = Settings::find(['category = :category: AND status = :status:', 'bind' => [':category' => $this->dispatcher->getActionName(), ':status' => Settings::ACTIVE]]);
        $this->view->setVars([
            'settings' => $settings,
            'category' => __(ucfirst($this->dispatcher->getActionName())),
            'priority' => \Las\Models\Services::priority(true)
        ]);

        // Check if the form has been sent
        if ($this->request->isPost() === true && $this->request->hasPost('submit')) {
            // Try to update settings
            $valid = Settings::qos($settings);

            // Check if data are valid
            if ($valid === TRUE) {
                $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The data has been saved."));
            } else {
                $this->view->setVar('errors', $valid);
                $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Please correct the errors."));
            }
        } else {
            // Values to fill out the form
            $this->tag->setDefaults($this->las[$this->dispatcher->getActionName()]);
        }
    }

}
