# Frappe-ERPNext-v13 installation
To install v13 of Frappe and ERPNext.

##  Pre-requisites :-
| Packages | Discription |
| --- | ----------- |
| Python 3.8.1 |
| Node.js 14 |
| Redis 5 | caching and real time updates |
| MariaDB 10.3.x / Postgres 9.5.x | to run database driven apps |
| Yarn 1.12+ | js dependency manager |
| Pip 20+ | py dependency manager |
| Wkhtmltopdf | for pdf generation |
| Cron | bench's scheduled jobs: automated certificate renewal, scheduled backups |
| Nginx | proxying multitenant sites in production |
  
  
## Instruction
-  Open terminal and execute
  ```sh v13script.sh```
- Script will ask for some inputs, enter them accordingly.
  
  
### Note
- Don't run this script with sudo or root.
- **Python** and **Nodejs** version has to be specific as given above to avoid any error and all other mentioned packages must install before executing.
