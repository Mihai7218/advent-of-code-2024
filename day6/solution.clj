(ns day6.solution
  (:require [clojure.string :as str]))

(defn get-start-pos [input]
  (let [lines (map-indexed (fn [index value] [index value]) (str/split-lines input))
        line (first (filter 
                     (fn [line] (str/includes? (get line 1) "^")) 
                     lines )) 
        x (get line 0)
        y (str/index-of (get line 1) "^")]
        [x y]))

(defn get-maze [input]
  (mapv (fn [x] (vec x)) (str/split-lines input)))

(defn loops? [maze init-pos init-direction init-visited n] 
  (loop [pos        init-pos
         direction  init-direction
         visited    init-visited]
    (let [x               (get pos 0)
          y               (get pos 1)
          dx              (get direction 0)
          dy              (get direction 1)
          nx              (+ x dx)
          ny              (+ y dy)
          new-pos         (if (= (get (get maze nx) ny) \#)
                            pos
                            [nx ny])
          maybe-direction (if (= dx 1)
                            [0 -1]
                            (if (= dx -1)
                              [0 1]
                              (if (= dy 1)
                                [1 0]
                                [-1 0])))
          new-direction   (if (= (get (get maze nx) ny) \#)
                            maybe-direction
                            direction)
          new-visited     (conj visited [pos direction])] 
      (if (or (< (get new-pos 0) 0) (< (get new-pos 1) 0) (>= (get new-pos 0) n) (>= (get new-pos 1) n))
        false
        (if (contains? visited [pos direction]) 
          true
          (recur new-pos new-direction new-visited))))))

(defn rec-solve [maze init-pos init-direction init-visited init-obstacles n]
  (loop [pos        init-pos
         direction  init-direction
         visited    init-visited
         obstacles  init-obstacles]
    (let [x               (get pos 0)
          y               (get pos 1)
          dx              (get direction 0)
          dy              (get direction 1)
          nx              (+ x dx)
          ny              (+ y dy)
          new-pos         (if (= (get (get maze nx) ny) \#)
                            pos
                            [nx ny])
          maybe-direction (if (= dx 1)
                            [0 -1]
                            (if (= dx -1)
                              [0 1]
                              (if (= dy 1)
                                [1 0]
                                [-1 0])))
          new-direction   (if (= (get (get maze nx) ny) \#)
                            maybe-direction
                            direction)
          new-visited     (conj visited [pos direction])
          new-maze        (if (= pos new-pos)
                            maze
                            (vec (map-indexed
                                  (fn [index value]
                                    (if (= index nx)
                                      (vec (map-indexed
                                            (fn [i2 v2]
                                              (if (= i2 ny)
                                                \#
                                                v2)) value))
                                      value))
                                  maze)))
          new-obstacles   (if (and
                               (not (= pos new-pos))
                               (loops? new-maze init-pos init-direction init-visited n)
                               (or (>= (get new-pos 0) 0) (>= (get new-pos 1) 0) (< (get new-pos 0) n) (< (get new-pos 1) n)))
                            (conj obstacles new-pos)
                            obstacles)]
      (if (or (< (get new-pos 0) 0) (< (get new-pos 1) 0) (>= (get new-pos 0) n) (>= (get new-pos 1) n)) 
        [(count (set (map (fn [x] (get x 0)) new-visited))) (count new-obstacles)]
        (recur new-pos new-direction new-visited new-obstacles)))))

(defn solve-maze [input]
  (let [start-pos (get-start-pos input)
        maze (get-maze input)
        result (rec-solve maze start-pos [-1 0] #{} #{} (count maze))] 
    (printf "Part 1: %d\n" (get result 0))
    (printf "Part 2: %d\n" (get result 1))))

(defn Solve []
  (let [input (slurp "input")]
    (solve-maze input)))
(Solve)