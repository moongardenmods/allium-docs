package com.example;

import java.util.List;
import java.util.Set;
import java.util.Map;
import java.util.HashMap;
import java.lang.Integer;
import java.lang.String;

public class CoerceExample {
    
    public static List<Integer> getList() {
        return List.of(3, 1, 4, 1, 5, 9);
    }

    public static Set<Integer> getSet() {
        return Set.of(3, 1, 4, 5, 9);
    }

    public static Map<String, Integer> getMap() {
        Map<String, Integer> map = new HashMap<>();
        map.put("hello", 5);
        map.put("world!", 6);
        return map;
    }
}