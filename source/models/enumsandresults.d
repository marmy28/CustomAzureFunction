module models.enumsandresults;
import std.algorithm.iteration : filter;
import std.algorithm.searching : all;
import std.array : array, empty, front;
import std.ascii : isLower;
import std.conv : to;
import std.getopt : getopt, defaultGetoptPrinter;
import std.string : strip, toLower;
import std.random : uniform;
import std.range : takeOne;
import std.stdio : readln, writefln, writeln;
import std.traits : EnumMembers;
import std.format;
// if you add to the number of choices here make sure
// to add the options into the getResult function
public enum GameChoices
{
    rock,
    paper,
    scissors
}
public enum MatchOutcome : ubyte
{
    win,
    lose,
    tied
}
public struct Response { GameChoices userChoice; GameChoices computerChoice; MatchOutcome matchOutcome; }
/**
* Looks at both the users choice and the computers choice to determine the matches outcome.
**/
public MatchOutcome getResult(in GameChoices userChoice, in GameChoices computerChoice) nothrow pure @safe @nogc
{
    if (userChoice == computerChoice)
        return MatchOutcome.tied;
    else
    {
        final switch (userChoice) with (GameChoices)
        {
            case rock:
                if (computerChoice == GameChoices.scissors)
                    return MatchOutcome.win;
                break;
            case scissors:
                if (computerChoice == GameChoices.paper)
                    return MatchOutcome.win;
                break;
            case paper:
                if (computerChoice == GameChoices.rock)
                    return MatchOutcome.win;
                break;
        }
        return MatchOutcome.lose;
    }
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.rock) == MatchOutcome.tied);
    assert(getResult(GameChoices.paper, GameChoices.paper) == MatchOutcome.tied);
    assert(getResult(GameChoices.scissors, GameChoices.scissors) == MatchOutcome.tied);
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.paper) == MatchOutcome.lose);
    assert(getResult(GameChoices.paper, GameChoices.scissors) == MatchOutcome.lose);
    assert(getResult(GameChoices.scissors, GameChoices.rock) == MatchOutcome.lose);
}
///
pure nothrow @nogc @safe unittest
{
    assert(getResult(GameChoices.rock, GameChoices.scissors) == MatchOutcome.win);
    assert(getResult(GameChoices.paper, GameChoices.rock) == MatchOutcome.win);
    assert(getResult(GameChoices.scissors, GameChoices.paper) == MatchOutcome.win);
}
@safe unittest
{
    immutable firstChoice = uniform!GameChoices;
    assert(getResult(firstChoice, firstChoice) == MatchOutcome.tied);
    GameChoices secondChoice = uniform!GameChoices;
    while (firstChoice == secondChoice) { secondChoice = uniform!GameChoices; }
    // if the choices are not the same then it should never be tie
    assert(getResult(firstChoice, secondChoice) != MatchOutcome.tied);
}

GameChoices getComputerChoice() @safe
{
	return uniform!GameChoices();
}
string resultForUser(in MatchOutcome matchOutcome, in GameChoices userChoice, in GameChoices computerChoice)
{
    auto outcome = matchOutcome.to!string;
    auto userChoiceString = userChoice.to!string;
    auto computerChoiceString = computerChoice.to!string;
    return format("User: %s, Computer: %s. You %s.", userChoiceString, computerChoiceString, outcome);
}
string resultForUser(in GameChoices userChoice)
{
    immutable computerChoice = getComputerChoice();
    immutable result = getResult(userChoice, computerChoice);
    return resultForUser(result, userChoice, computerChoice);
}

unittest
{
    import std.regex;
    auto ctr = ctRegex!(`User: rock, Computer: (rock|paper|scissors). You (win|lose|tied).`);
    immutable result = resultForUser(GameChoices.rock);
    auto c2 = matchFirst(result, ctr);   // First match found here, if any
    assert(!c2.empty);  
}
unittest
{
    immutable result = resultForUser(MatchOutcome.win, GameChoices.rock, GameChoices.rock);
    assert(result == "User: rock, Computer: rock. You win.");   // Be sure to check if there is a match before examining contents!
}