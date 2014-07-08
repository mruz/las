<?php

namespace Las\Extension;

use Las\Library\Dump;

/**
 * SQL Listener
 *
 * @package     las
 * @category    Extension
 * @version     1.0
 */
class Listener
{

    /**
     * Display Real SQL Statement
     *
     * <code>
     * $eventsManager = new \Phalcon\Events\Manager();
     * $eventsManager->attach('db', new \Las\Extension\Listener());
     * $this->db->setEventsManager($eventsManager);
     *
     * $query = $this->db->convertBoundParams('SELECT * FROM `users` WHERE `user_id` = :user_id:', array(':user_id' => 1));
     * $user = $this->db->fetchAll($query['sql'], \Phalcon\Db::FETCH_ASSOC, $query['params']);
     * </code>
     *
     * @package     las
     * @version     1.0
     */
    public function beforeQuery($event, $connection, $params)
    {
        $statement = $connection->getSQLStatement();
        // If params is not empty
        if (!empty($params)) {
            // Check if params is assoc array
            if (array_keys($params) !== range(0, count($params) - 1)) {
                // Real SQL Statement
                $statement = str_replace(array_keys($params), array_values($params), $statement);
            } else {
                // Real SQL Statement after convertBoundParams
                foreach ($params as $param) {
                    $statement = preg_replace('/\?/', '"' . $param . '"', $statement, 1);
                }
            }
        }
        echo Dump::all($statement);
    }

}
