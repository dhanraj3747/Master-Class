document.addEventListener("DOMContentLoaded", () => {
    // 1. Setup Intersection Observer for Slide-In Effects
    const observerOptions = {
        root: null,
        rootMargin: '0px 0px -50px 0px',
        threshold: 0.1
    };

    const slideObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('slide-visible');
                // Optional: Unobserve to make the animation play only once
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Select all elements that should have the slide effect
    const animatedElements = document.querySelectorAll('.card, .card1, .course-card, .career-card, .feature-box, .category-column-card, .footer-card, .slide-up');
    
    animatedElements.forEach(el => {
        // Initially hide the elements
        el.classList.add('slide-hidden');
        slideObserver.observe(el);
    });

    // 2. Add Horizontal Drag-to-Scroll for Card Wrappers (Data-driven UI interaction)
    const sliders = document.querySelectorAll('.cards-wrapper, .cert-container');
    
    sliders.forEach(slider => {
        let isDown = false;
        let startX;
        let scrollLeft;

        slider.addEventListener('mousedown', (e) => {
            isDown = true;
            slider.style.cursor = 'grabbing';
            startX = e.pageX - slider.offsetLeft;
            scrollLeft = slider.scrollLeft;
        });

        slider.addEventListener('mouseleave', () => {
            isDown = false;
            slider.style.cursor = 'default';
        });

        slider.addEventListener('mouseup', () => {
            isDown = false;
            slider.style.cursor = 'default';
        });

        slider.addEventListener('mousemove', (e) => {
            if (!isDown) return;
            e.preventDefault();
            const x = e.pageX - slider.offsetLeft;
            const walk = (x - startX) * 2; // Scroll speed multiplier
            slider.scrollLeft = scrollLeft - walk;
        });
    });
});