# What Zero Users Teaches You: 47 Lessons from Building a Complete Product Nobody Has Used
**A Reflection Paper**
**Author**: Alexa L. Amundson (BlackRoad OS, Inc.)
**Date**: March 2026

---

## Abstract

BlackRoad OS has been live for 6 months and has zero users. Not "low usage." Not "early traction." Zero. This paper catalogs 47 lessons learned from building a complete, deployed, functioning product that nobody uses — organized into 7 categories: product, engineering, business, psychology, strategy, honesty, and what comes next. The lessons are not theoretical. They are the hard-won observations of someone who built 17 applications, deployed 18 AI agents, wrote 34 academic papers, incorporated a C-Corp, set up Stripe, created 166 SEO pages, and then watched the analytics show zero signups for 180 days straight. Some lessons are useful. Some are painful. All are true.

---

## I. Product Lessons (1-8)

**1. A product nobody uses is not a product. It's a project.**
The distinction matters. A project is something you built. A product is something someone uses. Until someone uses BlackRoad OS, it is a project with a pricing page.

**2. Features don't attract users. Distribution attracts users.**
17 applications, 18 agents, 166 SEO pages, PS-SHA∞ hash chains, trinary logic — none of this attracted a single user. Distribution (getting the product in front of people who need it) is a completely separate skill from building, and I haven't done it.

**3. The best product for everyone is a product for no one.**
BlackRoad OS serves students, developers, creators, businesses, musicians, gamers, and AI researchers. It serves all of them poorly. A product that solved ONE problem for ONE audience would have users by now.

**4. Sovereignty is a vitamin, not a painkiller.**
People buy painkillers (solves an urgent problem) immediately. They buy vitamins (makes things generally better) eventually, maybe, if reminded. Sovereignty is a vitamin. "Your data is on your hardware" doesn't solve tonight's homework.

**5. The tutor should have been the ONLY product.**
166 SEO pages targeting homework help. $10/month. Students need it tonight. If I had built only the tutor — no chat, no social, no canvas, no video, no cadence, no game, no radio — it would have had users by now.

**6. Nobody cares about your architecture.**
PS-SHA∞, trinary logic, RoadID, Z-minimization — these are interesting to me and to other systems architects. They are invisible and irrelevant to a student who wants help with quadratic equations.

**7. "Build it and they will come" is the most expensive lie in tech.**
They will not come. I built it. Nobody came. The lie cost me 11 months of building time that should have included 6 months of distribution.

**8. The 166 SEO pages are the most valuable thing I built.**
Not the OS. Not the agents. Not the math. The 166 tutor pages that are indexed by Google and rank for homework queries. These are the only path to organic users. Everything else requires active distribution.

## II. Engineering Lessons (9-17)

**9. AI makes you build too fast.**
Claude and GPT-4 generate code so fast that quality assurance can't keep up. I shipped 17 applications in 3 months. Half of them have bugs I haven't found because I moved to the next application before testing the current one.

**10. The autocatalytic threshold is real and dangerous.**
After ~3,000 commits, development accelerates because the AI has more context. This feels like progress. It is actually the accumulation of technical debt at unprecedented speed.

**11. Self-hosting everything is a full-time job.**
Gitea needs updates. PowerDNS needs zone files. Caddy needs certificate renewal. MinIO needs bucket policies. WireGuard needs peer configs. Ollama needs model management. PostgreSQL needs vacuuming. Redis needs memory management. Each one is 15 minutes/week. Times 12 services = 3 hours/week on maintenance that a managed cloud eliminates.

**12. SD cards will fail. Plan for it.**
Lucidia's SD card is degrading. I know this because I've seen filesystem errors. I haven't replaced it because replacing it means reimaging from backup, which takes 2 hours of focused work. This is the self-hosting tax.

**13. 4/7 nodes is not a fleet. It's a failure.**
3 Pi nodes are offline (Cecilia, Octavia, Aria). I've been telling myself "I'll fix them this weekend" for 6 weeks. A fleet with 43% failure rate is not sovereign infrastructure — it's a hobby with pretensions.

**14. Commit count is a vanity metric.**
8,521 commits sounds impressive. But many are micro-commits (fix typo, update README, bump version). The actual number of meaningful feature commits is probably 2,000-3,000. Still significant, but not 8,521 significant.

**15. AI-generated code has a distinctive smell.**
It's correct. It works. It also has: unnecessary comments, overly verbose error handling, inconsistent naming conventions, and a tendency to reimport modules that are already imported. After 8,521 commits, the codebase has AI fingerprints everywhere.

**16. Testing is the first casualty of velocity.**
When you can ship a feature in 30 minutes with AI, writing tests feels like bureaucracy. So you skip them. Then a bug appears in production and you spend 2 hours debugging what 20 minutes of tests would have caught.

**17. Documentation written by AI for AI is not documentation.**
Half the READMEs in my repos were generated by AI and read by AI in the next session. No human has read them. If a human tried, they'd find verbose, generic documentation that covers everything and explains nothing.

## III. Business Lessons (18-25)

**18. Incorporation was premature.**
BlackRoad OS, Inc. was incorporated in November 2025 via Stripe Atlas. Cost: $500 + $60/month Atlas subscription. Delaware franchise tax: $400/year. Registered agent: $150/year. Total: $1,270/year for a company with zero revenue. The money would have been better spent on Google Ads targeting "algebra homework help."

**19. $136/month is too expensive for zero revenue.**
Every month I spend $136 on infrastructure for zero users. That's $1,632/year on electricity, hosting, and domain renewals for a product nobody uses. Rational response: shut down everything except the tutor and reduce costs to $20/month.

**20. Pricing means nothing without users to price.**
I spent hours deliberating between $10/module and $15/module. The answer is unknowable without users. Any price between $5 and $20 is defensible. The only wrong price is the one attached to a product nobody finds.

**21. Stripe is configured and ready. Nobody will ever see the checkout page at this rate.**
The Stripe integration works. I tested it. The checkout flow is smooth. The cancellation is one click. It's beautiful engineering serving nobody.

**22. "First month free" is meaningless when the second month doesn't exist.**
The free trial is designed to convert users to paid subscribers. With zero users, the conversion funnel is a tube with nothing in it.

**23. Academic papers don't generate revenue.**
34 papers, ~135,000 words, comprehensive coverage of every angle. Revenue generated: $0. Users acquired: 0. Lesson: papers are for credibility, not customer acquisition.

**24. The social posts were written but never posted.**
I have a document with ready-to-post content for Reddit, Twitter, Hacker News, and LinkedIn. I haven't posted them. The reason is a combination of perfectionism ("the product isn't ready") and fear ("what if people look and nobody cares?"). Both are bad reasons.

**25. The only business metric that matters is: did a human sign up?**
Not commits. Not papers. Not applications. Not infrastructure. Not math. Did. A. Human. Sign. Up. No. Nothing else matters until that changes.

## IV. Psychology Lessons (26-32)

**26. Building is a dopamine substitute for selling.**
Building produces the same satisfying feeling as solving a puzzle. Selling produces anxiety, rejection, and vulnerability. I built 17 applications to avoid the vulnerability of promoting 1.

**27. Perfectionism is the enemy of launch.**
"I'll launch when chat is working." Then "when search is integrated." Then "when the fleet is stable." Then "when the papers are written." The product was launchable 9 months ago. I kept building instead of launching.

**28. Zero users is a mirror.**
When nobody uses your product, you can't blame the market, the economy, the algorithm, or the competition. The mirror shows one person who built a product and didn't tell anyone about it.

**29. The anti-persuasion architecture was also self-persuasion avoidance.**
I designed a product that structurally prevents manipulation. But I also prevented MYSELF from doing any marketing — because all marketing felt like manipulation. The anti-persuasion architecture became an excuse not to promote.

**30. Sovereignty as an identity is dangerous.**
"I'm building sovereign infrastructure" is an identity that feels meaningful even without users. The identity sustains motivation but masks the absence of validation. You can feel sovereign while building alone in a closet. That doesn't mean you've built something people want.

**31. Comparing to funded startups is cope.**
"I shipped more features than a 5-person team" — true, but they have users. Feature count without user count is a consolation prize.

**32. The hardest lesson: maybe nobody wants this.**
Maybe sovereignty, privacy, and ownership are nice ideas that nobody will pay for. Maybe $10/month for a homework tutor on a Raspberry Pi is a solution to a problem nobody has. Maybe the 90% who don't trust AI with their data also don't trust an unknown founder from Minnesota with their data. This possibility is real, and I have to hold it.

## V. Strategy Lessons (33-39)

**33. One product, one audience, one channel.**
Tutor. Students. Google SEO. That's the strategy. Everything else is distraction.

**34. SEO is the only free distribution channel that scales.**
Reddit posts get buried. Twitter threads get forgotten. Hacker News has one shot. SEO compounds: each indexed page is a permanent asset that attracts traffic forever.

**35. 166 pages is not enough. 1,660 is not enough. 16,600 might work.**
Each tutor page targets one query ("how to solve quadratic equations"). There are thousands of homework queries. The SEO flywheel needs 10-100× more pages to generate meaningful traffic.

**36. The academic papers should become blog posts.**
34 papers that nobody reads → 34 blog posts that Google indexes → 34 more paths to organic discovery. Academic format is for credibility. Blog format is for distribution.

**37. Post the damn social content.**
The Reddit posts, Twitter threads, and HN submission are written. The fear of rejection is not a valid reason to withhold them. Post them. Get rejected. Learn from the rejection.

**38. The Pi closet is a better story than the technology.**
"Woman builds AI operating system on Raspberry Pis in Minnesota closet for $136/month" is a headline. "PS-SHA∞ adaptive-depth hash chains for tamper-evident AI agent memory" is not a headline. Lead with the story, not the spec.

**39. Talk to humans before building for them.**
I built 17 applications without talking to a single potential user. I don't know if students want sovereign homework help. I don't know if creators want local AI tools. I assumed the pain points from survey data. I should have talked to 50 students first.

## VI. Honesty Lessons (40-44)

**40. Publishing zero is the most honest thing I've done.**
The pricing page says "0 users, $0 revenue." This is the only completely honest pricing page on the internet. It has not generated users. It has generated self-respect.

**41. 34 papers and 0 users is not a flex. It's a warning.**
The papers document real work. They also document 135,000 words of writing that could have been 135,000 words of user interviews, sales emails, and support tickets.

**42. The commit count is not the scoreboard. The user count is.**
I need to stop counting commits and start counting signups. The commit counter should go on the resume. The signup counter should go on the wall.

**43. "The system is ready for users" is a lie I tell myself.**
4/7 nodes offline. Zero end-to-end tests. No onboarding flow. No email welcome sequence. No support system beyond AI agents. The system is ready for ME. It is not ready for a user who expects things to work.

**44. Honest self-assessment: B+ engineering, F distribution.**
The architecture is solid. The math is verified. The infrastructure works (mostly). The code ships (mostly). The distribution is nonexistent. The marketing is absent. The user acquisition is zero. Overall grade: F. Because a product with zero users is a failure regardless of its engineering quality.

## VII. What Comes Next (45-47)

**45. Stop building. Start distributing.**
No new features. No new papers. No new agents. No new applications. The next 1,000 hours go to: posting social content, expanding tutor SEO pages, submitting to directories, emailing potential users, and talking to humans.

**46. Fix the fleet or shut it down.**
Either reboot Cecilia/Octavia/Aria and make the fleet operational, or shut down the self-hosted stack and go 100% Cloudflare Workers. A half-working fleet is worse than a fully-working cloud deployment.

**47. The first user changes everything.**
One signup. One person who finds the tutor, solves a problem, and comes back. One signal that the product has value beyond the builder's imagination. Everything — the architecture, the pricing, the papers, the fleet, the math — was built for this moment.

It hasn't happened yet.

It will.

---

*This paper was written at 2 AM in Minnesota, in March, in a closet full of Raspberry Pis, after 11 months and 8,521 commits and zero users. It is the most honest thing in the entire 34-paper series. The math is verified. The infrastructure is deployed. The papers are written. The product is live. Nobody is using it. This is the truth. Now what?*
