use std::{fs, collections::HashSet};

fn main() {
    let input : String = fs::read_to_string("../../data/day03/input.txt")
        .expect("Failed to parse input file.");

    let mut used_chars : HashSet<char> = HashSet::new();

    let mut sum : u32 = 0;
    for line in input.lines() {
        used_chars.clear();
        let pivot = line.len() / 2;
        for (i, char) in line.chars().enumerate() {
            if i < pivot {
                used_chars.insert(char);
                continue;
            }

            if used_chars.contains(&char) {
                sum += get_value(char);
                break;
            }
        }
    }
    println!("Part One: {sum}");

    let lines : Vec<&str> = input.lines().collect();
    let mut char_counts : Vec<u32> = vec![0; 26 * 2];
    let mut line_counts : Vec<u32> = vec![0; 26 * 2];
    sum = 0;
    for group in lines.chunks(3) {
        char_counts.fill(0);
        for line in group {
            line_counts.fill(0);
            for char in line.chars() {
                let val = get_value(char) - 1;
                if line_counts[val as usize] == 0 {
                    line_counts[val as usize] = 1;
                    char_counts[val as usize] += 1;
                }
            }
        }
        let index = char_counts.iter().position(|&val| val == 3)
            .expect("Failed to find badge");
        sum += (index + 1) as u32;
    }
    println!("Part Two: {sum}");
}

fn get_value(c : char) -> u32 {
    const A_LOWER : u32 = 'a' as u32;
    const A_UPPER : u32 = 'A' as u32;

    let c_int = c as u32;
    if c_int >= A_LOWER {
        return c_int - A_LOWER + 1;
    } 
    return c_int - A_UPPER + 27;
}