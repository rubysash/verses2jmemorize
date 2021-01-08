# verses2jmemorize
Create topical flashcards from openbible.info

# Automatically Groups Cards into Sets of 10
Every 10 cards goes into a new category so you have small card sets to memorize

For example, if you have 20 cards in the "mighty" category, it will make a mighty0 for the first 10 and mighty1 for the next 10.   This makes it easier to study sets in smaller bites of just a few minutes here and there.

# Example:

PS C:\Users\User\Desktop> perl .\verses2jmemorize.pl mighty

UPDATING: mighty.csv

FOUND: 91 records

PS C:\Users\User\Desktop> type .\mighty.csv -Head 3

Frontside,Flipside,Category,Level

"1 Chronicles 29:11","Yours, O Lord, is the greatness and the power and the glory and the victory and the majesty, for all that is in the heavens and in the earth is yours. Yours is the kingdom, O Lord, and you are exalted as head above all.","mighty0",0

"1 Corinthians 10:13","No temptation has overtaken you that is not common to man. God is faithful, and he will not let you be tempted beyond your ability, but with the temptation he will also provide the way of escape, that you may be able to endure it.","mighty0",0

# Import to Jmemorize
Now you can import the csv file directly into the jmemorize app and you have (91) flashcards.
