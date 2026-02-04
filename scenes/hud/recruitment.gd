extends Popup

var recruits = []
const NUMBER_OF_RECRUITS = 5

func _ready() -> void:
	refreshRecruits()

func refreshRecruits():
	recruits = []
	while recruits.size() < NUMBER_OF_RECRUITS:
		var recruitName = NAMES.get(randf() * NAMES.size())
		recruits.push_back(recruitName)
	clearAndRepopulate()

func clearAndRepopulate():
	for n in $GridContainer.get_children():
		$GridContainer.remove_child(n)
		
	for recruitName in recruits:
		var recruitNameLabel = Label.new()
		recruitNameLabel.text = recruitName
		$GridContainer.add_child(recruitNameLabel)
		
		var hireRecruitButton = Button.new()
		hireRecruitButton.text = "Hire"
		hireRecruitButton.connect("pressed", hireRecruit.bind(recruitName))
		$GridContainer.add_child(hireRecruitButton)

func _on_timer_timeout() -> void:
	refreshRecruits()

func hireRecruit(recruitName: String) -> void:
	recruits.erase(recruitName)
	Globals.selectedNode.inventory.worker += 1
	clearAndRepopulate()

const NAMES = [
  "Matteo Ponce",
  "Adam Reilly",
  "Sameer Jones",
  "Eddie Saunders",
  "Lewis Burns",
  "Layton Price",
  "Owain Bradley",
  "Nicola Arroyo",
  "Alec Walsh",
  "Moshe Donaldson",
  "Calvin Mooney",
  "Trey Shields",
  "Savanna Casey",
  "Aston Banks",
  "Valentina Pennington",
  "Frankie Bell",
  "Shawn Pratt",
  "Loui Porter",
  "Heidi Mcgee",
  "Rachael Payne",
  "Asa Bonilla",
  "Tiana Hawkins",
  "Terry Turner",
  "Rajan Pace",
  "Aliya Carney",
  "Ibrahim Levy",
  "Owais Jensen",
  "Duncan Blackwell",
  "Fergus Marsh",
  "Abby Carr",
  "Eileen Ford",
  "Glenn Burton",
  "Doris Robles",
  "Amina Ramsey",
  "Adele Clayton",
  "Kyan Roth",
  "Vanessa Long",
  "Elena Beard",
  "Bertha Potts",
  "Fabian O'Ryan",
  "Elsie Gilbert",
  "Alice Deleon",
  "Finnian Lamb",
  "Md Farley",
  "Alysha Ramirez",
  "Montgomery Thompson",
  "Oakley Yates",
  "Elizabeth Cervantes",
  "Alex Keith",
  "Rhea Donovan",
  "Mehmet Holt",
  "Ebony Stewart",
  "Aliyah Prince",
  "Khadijah Molina",
  "Brooklyn Pearce",
  "Crystal Slater",
  "Cecilia Diaz",
  "Joel Higgins",
  "Sana Meadows",
  "Saira Obrien",
  "Lily-Mae Shah",
  "Sumaiya Mcclure",
  "Tamzin Estes",
  "Lawson Parrish",
  "Mya Blevins",
  "Amelia Delacruz",
  "Alma Huber",
  "Lennon Cain",
  "Kobi Vaughan",
  "Umar Mcdonald",
  "Darcy Orr",
  "Lydia Rodgers",
  "Edgar Jacobs",
  "Hope Jacobson",
  "Keane Knapp",
  "Kathryn Carey",
  "Lowri Combs",
  "Lyra Schwartz",
  "Frederick Haines",
  "Cindy Ray",
  "Rebekah Underwood",
  "Khalid Estrada",
  "Kurtis Richard",
  "Hollie Lang",
  "Cade Mcleod",
  "April Villa",
  "Jonah House",
  "Evangeline Lindsay",
  "Emilio Holloway",
  "Hari Barrett",
  "Belle Cook",
  "Connor Gonzalez",
  "Chester Gross",
  "Carter Spencer",
  "Rhiannon Newton",
  "Lenny Coleman",
  "Rosemary Nelson",
  "Georgie Goodwin",
  "Chantelle Ochoa",
  "Lucinda Carroll"
]
