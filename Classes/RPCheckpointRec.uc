class RPCheckpointRec extends Actor
	DependsOn(RPCheckpoint);

// Link to exsiting game save system "CheckpointRecord"
struct CheckpointRecord
{
	var array<TSoldierStorage> arrSoldierStorage;
	var array<TAlienStorage> arrAlienStorage;
};

var array<TSoldierStorage> arrSoldierStorage;
var array<TAlienStorage> arrAlienStorage;

DefaultProperties
{
}
