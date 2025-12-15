package com.example;

public class Animal {

    protected int speed;

    public Animal(int speed) {
        this.speed = speed;
    }

    protected boolean makesNoise() {
        return true;
    }

    public String noise(boolean chasing, int packSize) {
        return makesNoise() ? "*rustle, rustle*" : "*silence*";
    }
}