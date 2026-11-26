<?php
// app/core/App.php
// Router don gian: phan tich URL -> goi Controller::action(params)

class App
{
    protected string $controllerName;
    protected string $action;
    protected array $params = [];

    public function __construct()
    {
        $url = $_GET['url'] ?? '';

        if ($url === '') {
            if (!empty($_SERVER['PATH_INFO'])) {
                $url = $_SERVER['PATH_INFO'];
            } else {
                $requestUri = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?? '';
                $scriptDir = str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? ''));

                if ($scriptDir !== '' && $scriptDir !== '/' && str_starts_with($requestUri, $scriptDir)) {
                    $url = substr($requestUri, strlen($scriptDir));
                } else {
                    $url = $requestUri;
                }
            }
        }

        $url = preg_replace('#^/?index\.php/?#i', '', $url);
        $url = trim($url, '/');

        $segments = $url === '' ? [] : explode('/', $url);

        if (($segments[0] ?? '') === 'admin') {
            // admin/product/edit/5
            $this->controllerName = 'Admin' . ucfirst($segments[1] ?? 'dashboard') . 'Controller';
            $this->action = $segments[2] ?? 'index';
            $this->params = array_slice($segments, 3);
        } else {
            // product/detail/5
            $this->controllerName = ucfirst($segments[0] ?? 'home') . 'Controller';
            $this->action = $segments[1] ?? 'index';
            $this->params = array_slice($segments, 2);
        }

        $this->dispatch();
    }

    protected function dispatch(): void
    {
        if (!class_exists($this->controllerName)) {
            $this->abort404('Khong tim thay controller: ' . $this->controllerName);
        }

        $controller = new $this->controllerName();

        if (!method_exists($controller, $this->action)) {
            $this->abort404('Khong tim thay action: ' . $this->action);
        }

        call_user_func_array([$controller, $this->action], $this->params);
    }

    protected function abort404(string $debugMessage = ''): void
    {
        if (!headers_sent()) {
            http_response_code(404);
        }

        if ($debugMessage !== '') {
            error_log($debugMessage);
        }

        require __DIR__ . '/../views/errors/404.php';
        exit;
    }
}
