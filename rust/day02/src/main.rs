use std::fs;

fn main() {
    let input = fs::read_to_string("../../data/day02/input.txt")
        .expect("Failed to read input");

    // Part 1
    let mut score = 0;
    for line in input.lines() {
        let opponent_move = line.chars().nth(0)
            .expect(format!("Failed to parse player move from {line}").as_str());

        let encoded_player_move = line.chars().nth(2)
            .expect(format!("Failed to parse player move from {line}").as_str());

        let (player_move, move_value) = match encoded_player_move {
            'X' => ('A', shape_value('A')),
            'Y' => ('B', shape_value('B')),
            'Z' => ('C', shape_value('C')),
            _ => panic!()
        };

        score += move_value;

        if win_table(player_move) == opponent_move {
            score += 6;
        } else if win_table(opponent_move) != player_move {
            score += 3;
        }
    }
    println!("Part One: {score}");

    score = 0;
    // Part 2
    for line in input.lines() {
        let opponent_move = line.chars().nth(0)
            .expect(format!("Failed to parse player move from {line}").as_str());

        let (player_move, result_value) = match line.chars().nth(2) {
            Some('X') => (win_table(opponent_move), 0),
            Some('Y') => (opponent_move, 3),
            Some('Z') => (lose_table(opponent_move), 6),
            _ => panic!()
        };

        score += result_value + shape_value(player_move);
    }
    println!("Part Two: {score}");
}

fn win_table(shape : char) -> char {
    return match shape {
        'A' => 'C',
        'B' => 'A', 
        'C' => 'B',
        _ => panic!()
    }
}

fn lose_table(shape : char) -> char {
    return match shape {
        'A' => 'B',
        'B' => 'C',
        'C' => 'A',
        _ => panic!()
    }
}

fn shape_value(shape : char) -> i32 {
    return match shape {
        'A' => 1,
        'B' => 2,
        'C' => 3,
        _ => panic!()
    }
}