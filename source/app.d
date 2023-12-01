import vibe.core.core : runApplication;
import vibe.http.server;
import vibe.d;
import std.random : uniform;
import std.process : environment;

import models.enumsandresults;

void rand(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
	getResultAndWriteIt(getComputerChoice(), res);
}

void rock(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
	getResultAndWriteIt(GameChoices.rock, res);
}
void paper(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
	getResultAndWriteIt(GameChoices.paper, res);
}
void scissors(scope HTTPServerRequest req, scope HTTPServerResponse res)
{
	getResultAndWriteIt(GameChoices.scissors, res);
}

void getResultAndWriteIt(in GameChoices userChoice, scope HTTPServerResponse res)
{
	immutable result = resultForUser(userChoice);
	res.writeBody(result, "text/plain");
}

void main()
{
	immutable port = environment.get("FUNCTIONS_CUSTOMHANDLER_PORT", "8080").to!ushort;
	// todo: write rock paper scissors into api and then look into azure
    // We are now using URLRouter here
    auto router = new URLRouter;
    router.get("/api/HttpExample", &rand);
    // router.get("/rock", &rock);
    // router.get("/paper", &paper);
    // router.get("/scissors", &scissors);
	auto settings = new HTTPServerSettings;
	settings.port = port;
	settings.bindAddresses = ["::1", "127.0.0.1"];

	auto l = listenHTTP(settings, router);
	scope (exit) l.stopListening();

	runApplication();
}