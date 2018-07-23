<?php

namespace Las\Cli\Tasks;

use Las\Models\Clients;
use Las\Models\Devices;
use Las\Models\Firewalls;
use Las\Models\Payments;
use Las\Models\Tasks;

/**
 * Cron CLI Task
 *
 * @package     las
 * @category    Task
 * @version     1.0
 */
class CronTask extends MainTask
{

    /**
     * Main Action - las crontab
     *
     * @package     las
     * @version     1.0
     */
    public function mainAction()
    {
        // Check if there is some firewall to compile
        if ($firewall = Firewalls::findFirst('status=' . Firewalls::COMPILE)) {
            $firewall->status = Firewalls::COMPILED;
            $firewall->update();

            $this->dispatcher->forward([
                'task' => 'firewall',
                'action' => 'compile',
                'params' => [$firewall->id],
            ]);
        }

        // Check if there is some firewall to reload
        if ($firewall = Firewalls::findFirst('status=' . Firewalls::RELOAD)) {
            $firewall->status = Firewalls::COMPILED;
            $firewall->update();

            $this->dispatcher->forward([
                'task' => 'firewall',
                'action' => 'display',
                'params' => [$firewall->id],
            ]);
        }

        // Check if there is some task to run
        if ($task =Tasks::findFirst('status=' . Tasks::RELOAD . ' OR status=' . Tasks::ACTIVE . ' AND `when`!="@reboot" AND `when`!="@tmp" AND next< ' . time().' ORDER BY next ASC')) {
            $task->next = \Las\Library\Crontab::parse($task->when);
            $task->status = Tasks::ACTIVE;
            $task->update();

            switch ($task->type) {
                case Tasks::FIREWALL:
                    $this->dispatcher->forward([
                        'task' => 'firewall',
                        'action' => 'display',
                        'params' => [$task->firewall_id],
                    ]);
                    break;
                case Tasks::CUTOFF:
                    $this->dispatcher->forward([
                        'task' => 'cron',
                        'action' => 'cutoff',
                    ]);
                    break;
                case Tasks::PAYMENT:
                    $this->dispatcher->forward([
                        'task' => 'cron',
                        'action' => 'payment',
                    ]);
                    break;
                case Tasks::PING:
                    $this->dispatcher->forward([
                        'task' => 'cron',
                        'action' => 'ping',
                    ]);
                    break;
            }
        }
    }

    /**
     * Cutoff Action - change status for clients
     *
     * @package     las
     * @version     1.0
     */
    public function cutoffAction()
    {
        $balances = Payments::sum([
                    'conditions' => 'status=' . Payments::SUCCESS,
                    'column' => 'amount',
                    'group' => 'client_id',
        ]);
        foreach ($balances as $balance) {
            if ($balance->sumatory < 0) {
                $client = Clients::findFirst($balance->client_id);
                $tariff = $client->getTariff();

                // Change status
                $client->status = $balance->sumatory < -$tariff->amount ? Clients::DISCONNECTED : Clients::INDEBTED;
                $client->save();
            }
        }
    }

    /**
     * Firewall Action - run the firewall
     *
     * @package     las
     * @version     1.0
     */
    public function firewallAction()
    {
        $this->dispatcher->forward([
            'task' => 'firewall',
            'action' => 'display',
            'params' => $this->dispatcher->getParams(),
        ]);
    }

    /**
     * Payment Action - charge the subscription
     *
     * @package     las
     * @version     1.0
     */
    public function paymentAction()
    {
        $clients = Clients::find('status IN (' . Clients::ACTIVE . ',' . Clients::INDEBTED . ')');
        foreach ($clients as $client) {
            $tariff = $client->getTariff();

            // Add new payment
            $payment = new Payments();
            $payment->client_id = $client->id;
            $payment->amount = -$tariff->amount;
            $payment->description = __('Subscription :month', [':month' => __(strftime('%B', strtotime('-1 month')))]);
            $payment->status = Payments::SUCCESS;
            $payment->date = date('Y-m-d H:i:s');
            $payment->save();
        }
    }

    /**
     * Ping Action - ping all active devices
     *
     * @package     las
     * @version     1.0
     */
    public function pingAction()
    {
        $devices = Devices::find('status=' . Devices::ACTIVE);
        foreach ($devices as $device) {
            $ping = \Las\Library\Info::ping(long2ip($device->IP));

            if ($ping) {
                $device->lastActive = time();
                $device->update();
            }
        }
    }

    /**
     * Reboot Action - for running tasks after reboot
     *
     * @package     las
     * @version     1.0
     */
    public function rebootAction()
    {
        // Only one ACTIVE task is running at reboot
        if ($task = Tasks::findFirst('status=' . Tasks::ACTIVE . ' AND `when`="@reboot"')) {
            $this->dispatcher->forward([
                'task' => 'firewall',
                'action' => 'display',
                'params' => [$task->firewall_id],
            ]);
        }
    }

    /**
     * Tmp Action - for running temporarily tasks
     *
     * @package     las
     * @version     1.0
     */
    public function tmpAction()
    {
        // Only first ACTIVE task is running at temporarily
        if ($task = Tasks::findFirst('status=' . Tasks::ACTIVE . ' AND `when`="@tmp"')) {
            $this->dispatcher->forward([
                'task' => 'firewall',
                'action' => 'display',
                'params' => [$task->firewall_id],
            ]);
        }
    }

}
