(
SynthDef(\playTone, { |freq, duration|
	var w = SinOsc.ar(freq) * XLine.ar(1001,1,duration,add: -1,doneAction:2) / 1000;
	Out.ar(0,w!2);
}).add;
)

(
SynthDef(\recordTone, { |buffer|
	RecordBuf.ar(In.ar(0,2), buffer, loop: 0, doneAction: 2);
}).add;
)

(Routine({
	var recordfn = { |freq, duration, fileName|
		var server = Server.local;
		var buffer = Buffer.alloc(server, server.sampleRate * duration, 2);

		server.sync;

		server.makeBundle(func: {
			var player = Synth(\playTone, [\freq, freq, \duration, duration]);
			var recorder = Synth.after(player, \recordTone, [\buffer, buffer]);
		});

		duration.wait;

		buffer.write(
			"/Users/minerva/Temp/snd/" ++ fileName ++ ".wav",
			"WAVE",
			"int16",
			completionMessage: ["/b_free", buffer]
		);
	};

	var scale = Dictionary.newFrom(List[
		a4: 261.63,
		b4: 293.66,
		c4: 329.63,
		d4: 349.23,
		e4: 392.00,
		f4: 440.00,
		g4: 493.88,
		a5: 523.25]);

	scale.keysValuesDo({ |note, freq|
		recordfn.value(freq,0.5,note);
	});

}).next)
