package com.example;

// import ...

public class FooBar {
    private int integer;
    private long biginteger;
    private final List<Float> fineList = new ArrayList<>();
    private final List<Double> veryFineList = new ArrayList<>();

    public FooBar(int integer, long biginteger) {
        this.integer = integer;
        this.biginteger = biginteger;
    }

    public void addPrecise(float preciseNumber, double veryPreciseNumber) {
        fineList.add(preciseNumber);
        veryFineList.add(veryPreciseNumber);
    }

    public List<Float> getFineList() {
        return this.fineList;
    }

    public List<Double> getVeryFineList() {
        return this.veryFineList;
    }

    public Integer changeInteger(Integer newInteger) {
        Integer oldInteger = Integer.valueOf(this.integer);
        this.integer = newInteger;
        return oldInteger;
    }

    public Long changeBigInteger(Long newBigInteger) {
        Long oldBigInteger = Long.valueOf(this.biginteger);
        this.biginteger = newBigInteger;
        return oldBigInteger;
    }

    public boolean isLongString(String text) {
        return text.length() > 10;
    }

    public Boolean invert(Boolean value) {
        return Boolean.valueOf(!value);
    }
}