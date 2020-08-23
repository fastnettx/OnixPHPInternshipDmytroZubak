<?php

class User
{
    private $name;
    private $balance;

    public function __construct($n, $b)
    {
        $this->name = $n;
        $this->balance = $b;

    }

    private function getBalance()
    {
        return $this->balance;

    }

    private function getName()
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
        echo 'У пользователя ' . $this->getName() . ' сейчас на счету - ' . $this->getBalance() . '$';
        echo ' <br/>';
    }

    public function giveMoney($sum, $obj2)
    {
        if ($this->getBalance() >= $sum) {
            $this->removeFromAccount($sum);
            $obj2->addFromAccount($sum);
            echo 'Пользователь ' . $this->getName() . ' перечислил ' . $sum . '$' . ' пользователю ' . $obj2->getName();
            echo ' <br/>';
        } else {
            echo 'У пользователя ' . $this->getName() . ' не достаточно денег на счету';
        }
    }

}

$user1 = new User('Ivan', 500);
$user2 = new User('Vovan', 5000);

$user1->printStatus();
$user2->printStatus();
$user1->giveMoney(200, $user2);
$user1->printStatus();
$user2->printStatus();
$user2->giveMoney(1500, $user1);
$user1->printStatus();
$user2->printStatus();
$user2->giveMoney(15000, $user1);


