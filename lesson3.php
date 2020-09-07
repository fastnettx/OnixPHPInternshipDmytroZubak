<?php

namespace lesson3;

class User
{
    private $name;
    private $balance;

    public function __construct($n, $b)
    {
        $this->name = $n;
        $this->balance = $b;
    }

    public function getBalance()
    {
        return $this->balance;
    }

    public function getName()
    {
        return $this->name;
    }

    private function removeFromAccount($bal)
    {
        $this->balance -= $bal;
    }

    private function addFromAccount($bal)
    {
        $this->balance += $bal;
    }

    public function printStatus()
    {
        echo 'У пользователя ' . $this->getName() . ' сейчас на счету - ' . $this->getBalance() . '$' . PHP_EOL;
    }

    public function __toString()
    {
        return $this->name;
    }

    public function giveMoney($sum, $obj2)
    {
        if ($this->getBalance() >= $sum) {
            $this->removeFromAccount($sum);
            $obj2->addFromAccount($sum);
            echo 'Пользователь ' . $this->getName() . ' перечислил ' . $sum . '$' . ' пользователю ' . $obj2->getName() . PHP_EOL;
        } else {
            echo 'У пользователя ' . $this->getName() . ' не достаточно денег на счету' . PHP_EOL;
        }
    }

    public function listProducts($product_register)
    {
        $products = array();
        foreach ($product_register as $product) {
            if ($product->getUser() == $this->name) {
                $products[] = $product;
            }
        }
        return $products;
    }

    public function sellProduct(Product $product, User $user)
    {
        if ($product->getPrice() <= $user->getBalance() && $product->getUser() == $this->name) {
            $this->balance += $product->getPrice();
            $user->removeFromAccount($product->getPrice());
            $product->setUser($user);
            echo "Пользователь, {$this->name} продал продукт {$product->getName()} (цена - {$product->getPrice()} ), 
            пользователю {$user->getName()} " . PHP_EOL;
        } elseif ($product->getPrice() > $user->getBalance()) {
            echo "Пользователь, {$this->name} не может перечислить  {$product->getPrice()} , 
            пользователю {$user->getName()}  так как имеет только {$this->balance}" . PHP_EOL;
        } elseif ($product->getUser() !== $this->name) {

            echo "Пользователь, {$this->name} не может продать продукт {$product->getName()} 
            (цена - {$product->getPrice()} ),  так как он принадлежит пользователю {$user->getName()} " . PHP_EOL;
        }
    }
}

abstract class Product
{
    private $name;
    private $price;
    private $owner;
    private static $products = array();

    public function __construct($name, $price, User $owner)
    {
        $this->name = $name;
        $this->price = $price;
        $this->owner = $owner;
        static::registerProduct($this);
    }

    private static function registerProduct($product)
    {
        if (!in_array($product, self::$products)) {
            self::$products[] = $product;
        }
    }

    abstract public static function createRandomProduct(User $user);

    public function __toString()
    {
        return 'Наименование - ' . $this->name . ', цена - ' . $this->price . ', имя пользователя - ' . $this->owner . ';' . PHP_EOL;
    }

    public static function ProductRegister()
    {
        return self::$products;
    }

    public function getUser()
    {
        return $this->owner;
    }

    public function setUser(User $user)
    {
        $this->owner = $user;
    }

    public function getPrice()
    {
        return $this->price;
    }

    public function getName()
    {
        return $this->name;
    }

    public static function iterableProductAnonymousClass()
    {
        foreach (self::$products as $product) {
            $element = new class($product->name, $product->price, $product->owner) {
                private $name;
                private $price;
                private $user;

                public function __construct($name, $price, $user)
                {
                    $this->name = $name;
                    $this->price = $price;
                    $this->user = $user;
                }

                public function __toString()
                {
                    return 'Наименование - ' . $this->name . ', цена - ' . $this->price . ', имя пользователя - ' . $this->user . ';' . PHP_EOL;
                }
            };
            echo $element;
        }
    }
}


class  Processor extends Product
{
    private $frequency;

    public function __construct($name, $price, $owner, $frequency)
    {
        parent::__construct($name, $price, $owner);
        $this->frequency = $frequency;
    }

    public static function createRandomProduct(User $user)
    {
        $name = str_shuffle('abcdefg');
        $price = rand(100, 10000);
        $frequency = rand(10000, 150000);;
        return new Processor($name, $price, $user, $frequency);
    }
}

class Ram extends Product
{
    private $type;
    private $memory;

    public function __construct($name, $price, $owner, $type, $memory)
    {
        parent::__construct($name, $price, $owner);
        $this->type = $type;
        $this->memory = $memory;
    }

    public static function createRandomProduct(User $user)
    {
        $name = str_shuffle('abcdefg');
        $price = rand(10, 5000);;
        $type = mb_substr(str_shuffle('ddrdim123'), 0, 3);
        $memory = rand(128, 10000);
        return new Ram($name, $price, $user, $type, $memory);
    }
}

$user1 = new User('Ivan', 1000);
$user2 = new User('Sergey', 1500);
$prod1 = new Processor('i3', 500, $user1, 10000);
$prod2 = new Ram('samsung', 500, $user2, 'DDR1', 1024);
$prod3 = Processor::createRandomProduct($user1);
$prod4 = Ram::createRandomProduct($user2);

$reg = Product::ProductRegister();
$user1->listProducts($reg);

$user1->sellProduct($prod3, $user2);
$user2->sellProduct($prod4, $user1);





