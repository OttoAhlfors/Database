/*
DROP TABLE IF EXISTS AnimalSpecies, Habitat, Specimen CASCADE;

CREATE TABLE AnimalSpecies (
    AID         INTEGER,
    Name        VARCHAR(64),
    Nutrition   CHAR(1),
    Temperature FLOAT,
    Habitat     VARCHAR(64),
    minFlock    INTEGER,
    maxFlock    INTEGER,
    spaceRequirements   FLOAT        );
ALTER TABLE AnimalSpecies ADD CONSTRAINT PK_AnimalSpecies
    PRIMARY KEY(AID);
	
CREATE TABLE Habitat (
    HID         INTEGER,
    Name        VARCHAR(64),
    Habitat     VARCHAR(64),
    Size        FLOAT,
    Temperature FLOAT           );
ALTER TABLE Habitat ADD CONSTRAINT PK_Habitat
    PRIMARY KEY(HID);
	
CREATE TABLE Specimen (
    EID       INTEGER,
    AID       INTEGER,
    HID       INTEGER,
    Name      VARCHAR(64),
    BirthDate   DATE,
    Gender    CHAR(1),
    Weight    FLOAT,
    Height    FLOAT            );
ALTER TABLE Specimen ADD CONSTRAINT PK_Specimen
    PRIMARY KEY(EID);
ALTER TABLE Specimen ADD CONSTRAINT FK_Specimen1
    FOREIGN KEY(AID) REFERENCES AnimalSpecies(AID);
ALTER TABLE Specimen ADD CONSTRAINT FK_Specimen2
    FOREIGN KEY(HID) REFERENCES Habitat(HID);
	
CREATE TABLE Ancestry (
    EID     INTEGER,
    Parent  INTEGER      );
ALTER TABLE Ancestry ADD CONSTRAINT PK_Ancestry
    PRIMARY KEY(EID, Parent);
ALTER TABLE ancestry ADD CONSTRAINT FK_Ancestry1
    FOREIGN KEY(EID) REFERENCES Specimen(EID);
ALTER TABLE Ancestry ADD CONSTRAINT FK_Ancestry2
    FOREIGN KEY(Parent) REFERENCES Specimen(EID);

SET datestyle TO SQL, DMY;    



INSERT INTO Habitat VALUES(101, 'Woods', 'For tigers', 70.0, 35.0);
INSERT INTO Habitat VALUES(103, 'Woods II', 'For tigers', 70.0, 35.0);
INSERT INTO Habitat VALUES(102, 'Swamp', 'For slimes', 50.0, 30.0);
INSERT INTO AnimalSpecies VALUES(1, 'Tiger', 'S', 35.5, 'Not given', 1, 3, 20.0);
INSERT INTO Specimen VALUES(1001, 1, 101, 'Tigger', '05/04/2014', 'M', 30.0, 100.0);
INSERT INTO Specimen VALUES(1002, 1, 101, 'Kit-Kat', '17/11/2012', 'F', 30.0, 100.0);
INSERT INTO Specimen VALUES(1003, 1, 101, 'Khan', '02/02/2010', 'M', 30.0, 100.0);
INSERT INTO Specimen VALUES(1004, 1, 101, 'Nova', '01/03/2014', 'F', 30.0, 100.0);
INSERT INTO Specimen VALUES(1005, 1, 101, 'Young one', '01/03/2016', 'F', 30.0, 100.0);
*/

/*
a) Parents are not younger than their offsprings
b) AnimalSpecies Habitat information must coincide with the Habitat table. 
	Temperature should not differ more than 5 degrees of what the species needs.
c) If a compound (Habitat) becomes overbooked then we need a warning. You can compare Habitat size to specimen weight or height or use size as "number of animals possible." You decide.
d) Offsprings have at MOST one male, one female parent. Consider NULLS
*/

CREATE FUNCTION check_parent(e integer, p integer) RETURNS boolean
	LANGUAGE SQL
	AS $$
	BEGIN
		SELECT BirthDate FROM  WHERE eid = e < BirthDate WHERE eid = p
	END;
	$$;

CREATE TRIGGER parent_age
	BEFORE UPDATE ON Ancestry
	FOR EACH ROW
	EXECUTE FUNCTION check_parent(eid, parent);
	
INSERT INTO Ancestry VALUES(1001 ,1002);
	
SELECT * FROM Ancestry;