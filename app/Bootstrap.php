<?php

namespace Las;

use Las\Library\Auth;
use Las\Library\I18n;
use Las\Library\Email;
use Las\Library\Dump;

/**
 * Bootstrap
 *
 * @package     las
 * @category    Application
 * @version     1.0
 */
class Bootstrap extends \Phalcon\Mvc\Application
{

    private $_di;
    private $_config;

    /**
     * Bootstrap constructor - set the dependency Injector
     *
     * @package     las
     * @version     1.0
     *
     * @param \Phalcon\DiInterface $di
     */
    public function __construct(\Phalcon\DiInterface $di)
    {
        $this->_di = $di;

        $loaders = array('config', 'loader', 'timezone', 'i18n', 'db', 'filter', 'flash', 'crypt', 'auth', 'session', 'cookie', 'cache', 'url', 'router');

        // Register services
        foreach ($loaders as $service) {
            $this->$service();
        }

        // Register modules
        $this->registerModules(array(
            'frontend' => array(
                'className' => 'Las\Frontend\Module',
                'path' => ROOT_PATH . '/app/frontend/Module.php'
            ),
            'admin' => array(
                'className' => 'Las\Backend\Module',
                'path' => ROOT_PATH . '/app/backend/Module.php'
            ),
            'doc' => array(
                'className' => 'Las\Doc\Module',
                'path' => ROOT_PATH . '/app/doc/Module.php'
            )
        ));

        // Register the app itself as a service
        $this->_di->set('app', $this);

        // Set the dependency Injector
        parent::__construct($this->_di);
    }

    /**
     * Register an autoloader
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function loader()
    {
        $loader = new \Phalcon\Loader();
        $loader->registerNamespaces(array(
            'Las\Models' => ROOT_PATH . '/app/common/models/',
            'Las\Library' => ROOT_PATH . '/app/common/library/',
            'Las\Extension' => ROOT_PATH . '/app/common/extension/'
        ))->register();
    }

    /**
     * Set the config service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function config()
    {
        $config = new \Phalcon\Config\Adapter\Ini(ROOT_PATH . '/app/common/config/config.ini');
        $this->_di->set('config', $config);
        $this->_config = $config;
    }

    /**
     * Set the time zone
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function timezone()
    {
        date_default_timezone_set($this->_config->app->timezone);
    }

    /**
     * Set the language
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function i18n()
    {
        $this->_di->setShared('i18n', function() {
            return I18n::instance();
        });
    }

    /**
     * Set the security service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function security()
    {
        $config = $this->_config;
        $this->_di->set('security', function() use ($config) {
            $security = new \Phalcon\Security();
            $security->setDefaultHash($config->security->key);
            return $security;
        });
    }

    /**
     * Set the crypt service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function crypt()
    {
        $config = $this->_config;
        $this->_di->set('crypt', function() use ($config) {
            $crypt = new \Phalcon\Crypt();
            $crypt->setPadding(\Phalcon\Crypt::PADDING_ZERO);
            $crypt->setKey($config->crypt->key);
            return $crypt;
        });
    }

    /**
     * Set the auth service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function auth()
    {
        $this->_di->setShared('auth', function() {
            return Auth::instance();
        });
    }

    /**
     * Set the filter service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function filter()
    {
        $this->_di->set('filter', function() {
            $filter = new \Phalcon\Filter();
            $filter->add('repeat', new Extension\Repeat());
            $filter->add('escape', new Extension\Escape());
            $filter->add('ip2long', function($value) {
                return ip2long($value);
            });
            return $filter;
        });
    }

    /**
     * Set the cookie service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function cookie()
    {
        $this->_di->set('cookies', function() {
            $cookies = new \Phalcon\Http\Response\Cookies();
            return $cookies;
        });
    }

    /**
     * Set the database service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function db()
    {
        $config = $this->_config;
        $this->_di->set('db', function() use ($config) {
            return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
                "host" => $config->database->host,
                "username" => $config->database->username,
                "password" => $config->database->password,
                "dbname" => $config->database->dbname,
                "options" => array(
                    \PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'
                )
            ));
        });
    }

    /**
     * Set the flash service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function flash()
    {
        $this->_di->set('flashSession', function() {
            $flash = new \Phalcon\Flash\Session(array(
                'warning' => 'alert alert-warning',
                'notice' => 'alert alert-info',
                'success' => 'alert alert-success',
                'error' => 'alert alert-danger',
                'dismissable' => 'alert alert-dismissable',
            ));
            $flash->setAutoescape(false);
            return $flash;
        });
    }

    /**
     * Set the session service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function session()
    {
        $this->_di->set('session', function() {
            $session = new \Phalcon\Session\Adapter\Files();
            $session->start();
            return $session;
        });
    }

    /**
     * Set the cache service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function cache()
    {
        $config = $this->_config;
        foreach ($config->cache->services as $service => $section) {
            $this->_di->set($service, function() use ($config, $section) {
                // Load settings for some section
                $frontend = $config->$section;
                $backend = $config->{$frontend->backend};

                // Set adapters
                $adapterFrontend = "\Phalcon\Cache\Frontend\\" . $frontend->adapter;
                $adapterBackend = "\Phalcon\Cache\Backend\\" . $backend->adapter;

                // Set cache
                $frontCache = new $adapterFrontend($frontend->options->toArray());
                $cache = new $adapterBackend($frontCache, $backend->options->toArray());
                return $cache;
            });
        }
    }

    /**
     * Set the url service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function url()
    {
        $config = $this->_config;
        $this->_di->set('url', function() use ($config) {
            $url = new \Phalcon\Mvc\Url();
            $url->setBaseUri($config->app->base_uri);
            $url->setStaticBaseUri($config->app->static_uri);
            return $url;
        });
    }

    /**
     * Set the static router service
     *
     * @package     las
     * @version     1.0
     *
     * @return void
     */
    protected function router()
    {
        $this->_di->set('router', function() {
            $router = new \Phalcon\Mvc\Router(false);

            $router->setDefaults(array(
                'module' => 'frontend',
                'controller' => 'index',
                'action' => 'index'
            ));

            /*
             * All defined routes are traversed in reverse order until Phalcon\Mvc\Router
             * finds the one that matches the given URI and processes it, while ignoring the rest.
             */
            $frontend = new \Phalcon\Mvc\Router\Group(array(
                'module' => 'frontend',
            ));
            $frontend->add('/:controller/:action/:params', array(
                'controller' => 1,
                'action' => 2,
                'params' => 3,
            ));
            $frontend->add('/:controller/:int', array(
                'controller' => 1,
                'id' => 2,
            ));
            $frontend->add('/:controller[/]?', array(
                'controller' => 1,
            ));
            $frontend->add('/{action:(buy|contact)}[/]?', array(
                'controller' => 'static',
                'action' => 'action'
            ));
            $frontend->add('/');

            // Mount a group of routes for frontend
            $router->mount($frontend);

            /**
             * Define routes for each module
             */
            foreach (array('admin', 'doc') as $module) {
                $group = new \Phalcon\Mvc\Router\Group(array(
                    'module' => $module,
                ));
                $group->setPrefix('/' . $module);

                $group->add('/:controller/:action/:params', array(
                    'controller' => 1,
                    'action' => 2,
                    'params' => 3,
                ));
                $group->add('/:controller/:int', array(
                    'controller' => 1,
                    'id' => 2,
                ));
                $group->add('/:controller[/]?', array(
                    'controller' => 1,
                ));
                $group->add('[/]?', array());

                // Mount a group of routes for some module
                $router->mount($group);
            }

            $router->notFound(array(
                'controller' => 'index',
                'action' => 'notFound'
            ));

            return $router;
        });
    }

    /**
     * HMVC request in the application
     *
     * @package     las
     * @version     1.0
     *
     * @param array $location location to run the request
     *
     * @return mixed response
     */
    public function request($location)
    {
        $dispatcher = clone $this->getDI()->get('dispatcher');

        if (isset($location['controller'])) {
            $dispatcher->setControllerName($location['controller']);
        } else {
            $dispatcher->setControllerName('index');
        }

        if (isset($location['action'])) {
            $dispatcher->setActionName($location['action']);
        } else {
            $dispatcher->setActionName('index');
        }

        if (isset($location['params'])) {
            if (is_array($location['params'])) {
                $dispatcher->setParams($location['params']);
            } else {
                $dispatcher->setParams((array) $location['params']);
            }
        } else {
            $dispatcher->setParams(array());
        }

        $dispatcher->dispatch();

        $response = $dispatcher->getReturnedValue();
        if ($response instanceof \Phalcon\Http\ResponseInterface) {
            return $response->getContent();
        }

        return $response;
    }

    /**
     * Log message into file, notify the admin on stagging/production
     *
     * @package     las
     * @version     1.0
     *
     * @param mixed $messages messages to log
     */
    public static function log($messages)
    {
        $config = \Phalcon\DI::getDefault()->getShared('config');

        if ($config->app->env == "development") {
            foreach ($messages as $key => $message) {
                echo Dump::one($message, $key);
            }
            exit();
        } else {
            $logger = new \Phalcon\Logger\Adapter\File(ROOT_PATH . '/app/common/logs/' . date('Ymd') . '.log', array('mode' => 'a+'));
            $log = '';

            foreach ($messages as $key => $message) {
                if (in_array($key, array('alert', 'debug', 'error', 'info', 'notice', 'warning'))) {
                    $logger->$key($message);
                } else {
                    $logger->log($message);
                }
                $log .= Dump::one($message, $key);
            }

            if ($config->app->env != "testing") {
                $email = new Email();
                $email->prepare(__('Something is wrong!'), $config->app->admin, 'error', array('log' => $log));

                if ($email->Send() !== true) {
                    $logger->log($email->ErrorInfo);
                }
            }

            $logger->close();
            return $log;
        }
    }

    /**
     * Catch the exception and log it, display pretty view
     *
     * @package     las
     * @version     1.0
     *
     * @param \Exception $e
     */
    public static function exception(\Exception $e)
    {
        $config = \Phalcon\DI::getDefault()->getShared('config');
        $errors = array(
            'error' => get_class($e) . '[' . $e->getCode() . ']: ' . $e->getMessage(),
            'info' => $e->getFile() . '[' . $e->getLine() . ']',
            'debug' => "Trace: \n" . $e->getTraceAsString() . "\n",
        );

        if ($config->app->env == "development") {
            // Display debug output
            echo Dump::all($errors);
        } else {
            // Display pretty view of the error
            $di = new \Phalcon\DI\FactoryDefault();
            $view = new \Phalcon\Mvc\View\Simple();
            $view->setDI($di);
            $view->setViewsDir(ROOT_PATH . '/app/frontend/views/');
            $view->registerEngines(\Las\Library\Tool::registerEngines($view, $di));
            echo $view->render('error', array('i18n' => I18n::instance(), 'config' => $config));

            // Log errors to file and send email with errors to admin
            \Las\Bootstrap::log($errors);
        }
    }

}
