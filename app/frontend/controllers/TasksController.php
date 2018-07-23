<?php

namespace Las\Frontend\Controllers;

use Las\Library\Las;
use Las\Models\Tasks;
use Las\Models\Firewalls;

/**
 * Frontend Tasks Controller
 *
 * @package     las
 * @category    Controller
 * @version     1.0
 */
class TasksController extends IndexController
{

    /**
     * Tmp action - run the temporarily firewall
     *
     * @package     las
     * @version     1.0
     */
    public function tmpAction()
    {
        if ($task = Tasks::findFirst('status=' . Tasks::ACTIVE . ' AND [when]="@tmp"')) {
            $firewall = $task->getFirewall();

            if ($firewall) {
                if ($firewall->status == Firewalls::RELOAD) {
                    // Display notice flash
                    $this->tag->setTitle(__('Notice'));
                    $this->view->setVar('title', __('Notice'));
                    $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("The :name firewall was scheduled to reload.", [':name' => '<i>' . $firewall->name . '</i>']));
                } elseif ($firewall->status == Firewalls::COMPILED) {
                    $this->tag->setTitle(__('Turn on the temporary access'));
                    $this->view->pick('msg');

                    // Reload at real time or trigger reload
                    if ($this->las['general']['realTime'] && $this->las['general']['rootPassword']) {
                        try {
                            // Try to run command as root
                            Las::cmd('php ' . ROOT_PATH . '/private/index.php firewall display ' . $firewall->id . ' | sh', true);

                            $this->tag->setTitle(__('Success'));
                            $this->view->setVar('title', __('Success'));
                            $this->flashSession->success($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Success') . '!</strong> ' . __("The :name firewall was reloaded.", [':name' => '<i>' . $firewall->name . '</i>']));
                        } catch (Exception $e) {
                            $errors = [
                                'error' => get_class($e) . '[' . $e->getCode() . ']: ' . $e->getMessage(),
                                'info' => $e->getFile() . '[' . $e->getLine() . ']',
                                'debug' => "Trace: \n" . $e->getTraceAsString() . "\n",
                            ];

                            \Las\Bootstrap::log($errors);

                            // Display warning flash
                            $this->tag->setTitle(__('Warning'));
                            $this->view->setVar('title', __('Warning'));
                            $this->flashSession->warning($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Warning') . '!</strong> ' . __("Something is wrong!"));
                        }
                    } else {
                        // Trigger reload - update firewall's status
                        $firewall->status = Firewalls::RELOAD;
                        $firewall->update();

                        // Display notice flash
                        $this->tag->setTitle(__('Notice'));
                        $this->view->setVar('title', __('Notice'));
                        $this->flashSession->notice($this->tag->linkTo(['#', 'class' => 'close', 'title' => __("Close"), '×']) . '<strong>' . __('Notice') . '!</strong> ' . __("The :name firewall was scheduled to reload.", [':name' => '<i>' . $firewall->name . '</i>']));
                    }
                }
            } else {
                $this->response->redirect(null);
            }
        } else {
            parent::notFoundAction();
        }
    }

}
