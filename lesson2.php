<?php

namespace user_product;

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
    }


    public static function registerProduct($product)
    {
        if (!in_array($product, self::$products)) {
            self::$products[] = $product;
        }
    }

    public function __toString()
    {
        return 'Наименование - ' . $this->name . ', цена - ' . $this->price . ', имя пользователя - ' . $this->owner . ';' . PHP_EOL;
    }

    public static function iterableProduct()
    {
        foreach (self::$products as $product) {
            echo $product;
        }
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
}

$user1 = new User('Ivan', 1200);
$user2 = new User('Sergey', 1200);
$prod1 = new Processor('i3', 100, $user1, 10000);
$prod2 = new Ram('samsung', 500, $user1, 'DDR1', 1024);
$prod3 = new Processor('i5', 200, $user2, 50000);;

Product::registerProduct($prod1);
Product::registerProduct($prod2);
Product::registerProduct($prod3);

Product::iterableProduct();
Product::iterableProductAnonymousClass();



