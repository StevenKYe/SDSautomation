# SDSautomation
This project aims at optimizing the SDS geometry to find the highest SBS gain.

## TODO
- [ ] Add the autodetect neff feature
- [x] Add the adaptive search algorithm for SBS gain
- [x] Create script to visualize the results
- [X] Create the initial population
- [X] Create the second generation without mutation
- [x] Mutate the second generation
- [x] Add fprintf to indicate the status of the program
- [x] Increase the size of the population


## Issues
- [x] diffProp could become zero after several rounds
- [x] runCOMSOL result doesn't match with the appliction results

## Gene pool setting
### 1st run
```matlab
tgSpan = linspace(160, 190, 7);
tintSpan = linspace(450, 550, 11);
tcSpan = linspace(7.8, 8.3, 26);
wSpan = linspace(2600, 3400, 17);
population = 20; % Population for the genetic evolution
rounds = 10; % 10 rounds for evolutions
```