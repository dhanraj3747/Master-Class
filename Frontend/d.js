document.addEventListener('DOMContentLoaded', () => {
    
    // 1. DYNAMIC GREETING & DATE
    const updateHeader = () => {
        const greeting = document.getElementById('greeting');
        const dateEl = document.getElementById('current-date');
        const now = new Date();
        const hour = now.getHours();

        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        dateEl.textContent = now.toLocaleDateString('en-US', options);

        if (hour < 12) greeting.textContent = "Good Morning, Alex!";
        else if (hour < 18) greeting.textContent = "Good Afternoon, Alex!";
        else greeting.textContent = "Good Evening, Alex!";
    };
    updateHeader();

    // 2. LINE CHART (Learning Activity)
    const ctxActivity = document.getElementById('activityChart').getContext('2d');
    new Chart(ctxActivity, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Study Hours',
                data: [2.5, 3.8, 1.5, 4.2, 3.0, 5.5, 4.8],
                borderColor: '#2563EB',
                backgroundColor: 'rgba(37, 99, 235, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: '#2563EB'
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { display: false } },
                x: { grid: { display: false } }
            }
        }
    });

    // 3. RADAR CHART (Skill Breakdown)
    const ctxSkill = document.getElementById('skillRadar').getContext('2d');
    new Chart(ctxSkill, {
        type: 'radar',
        data: {
            labels: ['Coding', 'Design', 'Data', 'Logic', 'Marketing', 'Soft Skills'],
            datasets: [{
                label: 'Skill Level',
                data: [90, 70, 85, 60, 40, 75],
                backgroundColor: 'rgba(139, 92, 246, 0.2)',
                borderColor: '#8B5CF6',
                borderWidth: 2,
                pointBackgroundColor: '#8B5CF6'
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: {
                r: { angleLines: { display: false }, suggestedMin: 0, suggestedMax: 100 }
            }
        }
    });

    // 4. PROGRESS BAR ANIMATION
    const animateProgress = () => {
        const bars = document.querySelectorAll('.progress-bar');
        bars.forEach(bar => {
            const targetWidth = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.transition = 'width 1.5s cubic-bezier(0.17, 0.67, 0.83, 0.67)';
                bar.style.width = targetWidth;
            }, 300);
        });
    };
    animateProgress();

    // 5. SEARCH BAR INTERACTION
    const searchInput = document.querySelector('.search-wrapper input');
    searchInput.addEventListener('focus', () => {
        document.querySelector('.search-wrapper').style.borderColor = '#2563EB';
        document.querySelector('.search-wrapper').style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)';
    });
    searchInput.addEventListener('blur', () => {
        document.querySelector('.search-wrapper').style.borderColor = '#E5E7EB';
        document.querySelector('.search-wrapper').style.boxShadow = 'none';
    });

    // 6. NOTIFICATION TOAST (Simulated)
    setTimeout(() => {
        console.log("Insight: Your 'Python' skill has improved by 5% today!");
    }, 5000);
});