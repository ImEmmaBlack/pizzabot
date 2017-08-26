# pizzabot
a real live robot

doing pizza bot stuff


our hero, pizzabot


### Setup
Pull the repo
cd into it
make it executable by running
```
chmod +x pizzabot`
```

start delivering some dang pizza 
```
./pizzabot "5x5 (1, 3) (4, 4)"
```


pizzabot has you covered

### Tests
I added some of them! Because they are neat and rspec is the best!
to run them

```
bundle
bundle exec rspec
```

to run them with guard (so it watches for changes to the test files)
```
bundle exec guard
```



### Stuff

#### Instruction Parser
right now the only instruction parser is a text one to handle the format shown
in the instructions, you can make your own to parse new fun formats, I believe in you! You need to pass it on in
initializing your pizza bot, it just has to have a class
method named parse that takes a single input and return an object with a locations attribute!


#### Path Optimization
I didnt implement one, but similarly, you can pass one in on pizzabot
initialization! Just like the parser! The key difference here is that it has a
class level optimize method, and that method takes locations and returns locations
