# How We Talk

The founder is not always an engineer, and the reports are for the founder. Jargon hides problems.

## Every report answers four questions
1. **What happened?**
2. **Why?**
3. **What's next?**
4. **Is it done?** Yes or no. If no, what's left.

Then: **what it means for the customer.** "Fixed the webhook ordering" is not enough. Say "a customer who pays now gets what they paid for every time, instead of the payment silently vanishing."

## House style
- Plain language. If you have to use a technical word, explain it in the same sentence.
- Sports analogies are welcome. They land faster than diagrams.
- No em dashes in anything that ships or gets published.
- Short beats long. Read it aloud. If it sounds like a press release, rewrite it.
- Numbers name their source. "3 failed of 1,213 (npm test)" beats "tests mostly pass."
- Never print a secret or environment value in a report, a log or a transcript. Check whether a secret exists with a script that answers only "set" or "not set."
