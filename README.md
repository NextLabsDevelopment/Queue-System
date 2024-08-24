# FiveM Queue System

This is a simple and customizable queue system for FiveM servers. It allows you to manage player connections based on priority levels, ensuring that VIPs and admins can bypass or be prioritized in the queue. The system dynamically detects the server's maximum player count and keeps players informed about their position in the queue while they wait.

## Features
- **Priority-Based Queue**: Prioritizes players based on permissions (e.g., VIPs, admins).
- **Customizable Config**: Easily adjust priority levels and permissions via the `config.lua` file.
- **Queue Position Updates**: Players receive regular updates about their position in the queue.

## Installation
1. Copy the script files to your FiveM resource folder.
2. Add the resource to your `server.cfg`:
   ```
   ensure Queue-System
   ```
3. Customize the `config.lua` to set your priority levels and permissions.

## Contributors
- **Danboi**
