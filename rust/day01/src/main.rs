use std::fs;

fn main() {
    let input : String = fs::read_to_string("../../data/day01/input.txt")
        .expect("Could not read file.");
    
    let mut accum : i32 = 0;
    let mut vec : Vec<i32> = Vec::new();
    for line in input.lines() {
        if line.is_empty() {
            vec.push(accum);
            accum = 0;
            continue;
        }

        let value = line.parse::<i32>()
            .expect(format!("Failed to parse int from string {line}").as_str());
        accum += value;
    }
    vec.sort();

    println!("Part One: {}", vec[vec.len() - 1]);

    let mut sum = 0;
    for i in 1..4 {
        sum += vec[vec.len() - i];
    }
    println!("Part Two: {sum}");
}
