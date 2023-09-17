# CaloriMeter
## Inspiration
We know how important it is for people to track their nutritional intake, whether for personal health or medical conditions. But, it can often be a hassle or even inaccessible to track calories of the meals we eat. And the problem only grows when including sugars, proteins and fats. When we were considering ways to simplify this problem, we considered the convenience and existing infrastructure of smart wallets and digital banking. Digital wallets allow you to pay with the tap of your phone and track purchases in-app. And, we considered systems like PRESTO and WatCard. Our solution, CaloriMeter, intersects these ideas with restaurant metrics to create the perfect food tracker.

## What it does
CaloriMeter provides caloric and nutritional intake at the instant of purchase. CaloriMeter acts as a smart card for paying at CaloriMeter-partnered restaurants and dining locations. When paying with CaloriMeter, nutritional data gets sent directly to your phone, no fuss. CaloriMeter-partnered restaurants help expand our database by providing accurate information about their foods. In your hands, you have all the power of data, without the need to collect it. 

## How we built it
We divided the project into three parts: an admin panel for web, a vendor app for mobile, and a customer app for mobile. We used Flutter to develop the mobile apps and Sveltekit for the admin panel. Each of us took control of one of the three parts, with our database bridging between.

## Challenges we ran into
Because we did not have an actual NFC reader for testing payments, we had to substitute with QR scanning. It was also the first time for us exploring mobile development with Firebase and Flutter. We faced difficulties with materializing our ideas in a language we did not speak (code).

## Accomplishments that we're proud of
We are proud of having been able to learn something new so quickly. In the end, we manaaged to make the product we aimed for.

## What we learned
We learned 

## What's next for CaloriMeter
CaloriMeter has many steps to becoming a production-ready product. In terms of cybersecurity, we have some work to do to protect and prevent misuse of the database from bad actors. With more time and the proper equipments for testing, we would use financial services like [Stripe](https://stripe.com/en-ca) and [Plaid](https://plaid.com/) to create a smart wallet. We think CaloriMeter is a great idea that has the potential to be so much more: for example, monitoring caffeine and medication intake. Someday, Calorimeter could be part of your digital world. 
