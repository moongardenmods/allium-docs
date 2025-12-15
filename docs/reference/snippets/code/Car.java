package com.example;

public class Car {
    private int speed;
    private int gas;
    private final int wheels;

    public Car(int speed) {
        this.speed = speed+5;
        this.wheels = 4;
        this.gas = 100;
    }

    private boolean isSpeeding() {
        return gas > 0 && speed > 10;
    }

    public int getRemainingGas() {
        return this.gas;
    }

    public String drive() {
        if (gas == 0) {
            return "*sputter*";
        } else if (wheels < 4) {
            gas--;
            return "putt putt putt";
        } else if (isSpeeding()) {
            gas-=5;
            return "VROOM!!!";
        } else {
            gas--;
            return "vroom!";
        }
    }
}