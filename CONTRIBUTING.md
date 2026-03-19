# Contributing

Thank you for your interest in contributing to **FreeCAD Manager**

---

## How to Contribute

1. Fork the repository
2. Clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/freecad-manager.git
cd freecad-manager
```

3. Create a new branch:

```bash
git checkout -b feature/your-feature-name
```

4. Make your changes

5. Test your changes locally

6. Commit your changes:

```bash
git commit -m "Add: short description of the change"
```

7. Push to your fork:

```bash
git push origin feature/your-feature-name
```

8. Open a Pull Request

---

## Guidelines

* Keep the script simple and readable
* Follow Bash best practices
* Avoid unnecessary dependencies
* Ensure compatibility with Ubuntu systems
* Document any new feature in README

---

## Code Style

* Use `set -euo pipefail`
* Use descriptive variable names
* Keep functions modular
* Add comments where needed

---

## Testing

Before submitting a PR:

* Test installation from local AppImage
* Test installation from URL
* Test uninstall
* Verify launcher works (`freecad`)

---

## Security

Do not introduce unsafe commands or behaviors.
If unsure, open an issue before implementing.

---

## Feature Requests

You can suggest improvements by opening an issue.

---

## Questions

If you have questions, open an issue and describe your problem clearly.

---

## Thanks

Your contributions help improve this project and make it more useful for the community.
