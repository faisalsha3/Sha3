-- Monaha Scholarship Platform Database Schema
-- Complete SQL schema for all classes and entities identified in the HTML file

-- Users table for authentication and basic user information
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'student' CHECK (role IN ('student', 'admin')),
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'inactive')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User profiles for detailed user information
CREATE TABLE user_profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    nationality VARCHAR(100),
    address TEXT,
    education_level VARCHAR(50) CHECK (education_level IN ('high-school', 'bachelor', 'master', 'phd')),
    field_of_study VARCHAR(255),
    gpa VARCHAR(50),
    english_proficiency VARCHAR(50) CHECK (english_proficiency IN ('native', 'fluent', 'advanced', 'intermediate', 'basic', 'toefl', 'ielts')),
    work_experience TEXT,
    skills TEXT,
    interests TEXT,
    career_goals TEXT,
    profile_completion_percentage INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Scholarships table
CREATE TABLE scholarships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    country VARCHAR(10) NOT NULL CHECK (country IN ('us', 'uk', 'ca', 'au', 'de')),
    program VARCHAR(50) NOT NULL CHECK (program IN ('bachelor', 'master', 'phd')),
    funding VARCHAR(50) NOT NULL CHECK (funding IN ('full', 'partial', 'tuition')),
    deadline DATE NOT NULL,
    requirements TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Universities table
CREATE TABLE universities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    country VARCHAR(10) NOT NULL,
    ranking INTEGER,
    acceptance_rate VARCHAR(10),
    student_count VARCHAR(20),
    tuition VARCHAR(50),
    tuition_range VARCHAR(20) CHECK (tuition_range IN ('free', 'low', 'medium', 'high')),
    website_url VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- University programs table
CREATE TABLE university_programs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    university_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    level VARCHAR(50) NOT NULL CHECK (level IN ('bachelor', 'master', 'phd')),
    duration VARCHAR(50),
    field_of_study VARCHAR(100),
    description TEXT,
    requirements TEXT,
    tuition VARCHAR(50),
    language VARCHAR(50) DEFAULT 'English',
    application_deadline DATE,
    start_date DATE,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
);

-- University offers table (scholarships and special programs)
CREATE TABLE university_offers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    university_id INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('scholarship', 'program', 'exchange', 'internship')),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    amount VARCHAR(100),
    deadline DATE,
    requirements TEXT,
    eligibility_criteria TEXT,
    application_process TEXT,
    contact_info TEXT,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
);

-- University fields of study table
CREATE TABLE university_fields (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    university_id INTEGER NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    department VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
    UNIQUE(university_id, field_name)
);

-- Documents table for file management
CREATE TABLE documents (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('transcript', 'cv', 'letter', 'essay', 'certificate', 'other')),
    file_name VARCHAR(255) NOT NULL,
    file_size INTEGER,
    file_path VARCHAR(500),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Applications table for scholarship applications
CREATE TABLE applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    scholarship_id INTEGER NOT NULL,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'under_review', 'accepted', 'rejected')),
    submitted_at TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(id) ON DELETE CASCADE,
    UNIQUE(user_id, scholarship_id)
);

-- Forum posts table for community features
CREATE TABLE forum_posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    author_name VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('general', 'scholarships', 'applications', 'universities', 'success', 'help')),
    likes INTEGER DEFAULT 0,
    replies INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Forum replies table
CREATE TABLE forum_replies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    author_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Motivation letters table
CREATE TABLE motivation_letters (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    letter_number INTEGER NOT NULL CHECK (letter_number IN (1, 2, 3)),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    template_type VARCHAR(50) CHECK (template_type IN ('general', 'research', 'leadership', 'international')),
    related_scholarship_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (related_scholarship_id) REFERENCES scholarships(id) ON DELETE SET NULL,
    UNIQUE(user_id, letter_number)
);

-- CV data table
CREATE TABLE cv_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    full_name VARCHAR(255),
    professional_title VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    education TEXT,
    skills TEXT,
    work_experience TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Password reset tokens table
CREATE TABLE password_reset_tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(10) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User favorites/saved items table
CREATE TABLE user_favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    item_type VARCHAR(50) NOT NULL CHECK (item_type IN ('scholarship', 'university')),
    item_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, item_type, item_id)
);

-- System settings table for admin configuration
CREATE TABLE system_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table for user notifications
CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error')),
    read_status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Activity logs table for tracking user actions
CREATE TABLE activity_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action VARCHAR(100) NOT NULL,
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_scholarships_country ON scholarships(country);
CREATE INDEX idx_scholarships_program ON scholarships(program);
CREATE INDEX idx_scholarships_deadline ON scholarships(deadline);
CREATE INDEX idx_scholarships_status ON scholarships(status);
CREATE INDEX idx_universities_country ON universities(country);
CREATE INDEX idx_universities_ranking ON universities(ranking);
CREATE INDEX idx_universities_tuition_range ON universities(tuition_range);
CREATE INDEX idx_university_programs_university_id ON university_programs(university_id);
CREATE INDEX idx_university_programs_level ON university_programs(level);
CREATE INDEX idx_university_programs_field ON university_programs(field_of_study);
CREATE INDEX idx_university_offers_university_id ON university_offers(university_id);
CREATE INDEX idx_university_offers_type ON university_offers(type);
CREATE INDEX idx_university_offers_deadline ON university_offers(deadline);
CREATE INDEX idx_university_fields_university_id ON university_fields(university_id);
CREATE INDEX idx_documents_user_id ON documents(user_id);
CREATE INDEX idx_documents_type ON documents(type);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_applications_scholarship_id ON applications(scholarship_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_forum_posts_user_id ON forum_posts(user_id);
CREATE INDEX idx_forum_posts_category ON forum_posts(category);
CREATE INDEX idx_forum_replies_post_id ON forum_replies(post_id);
CREATE INDEX idx_motivation_letters_user_id ON motivation_letters(user_id);
CREATE INDEX idx_cv_data_user_id ON cv_data(user_id);
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read_status ON notifications(read_status);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

-- Insert default system settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('site_name', 'Monaha', 'Name of the scholarship platform'),
('site_description', 'Complete Scholarship Platform', 'Description of the platform'),
('max_file_size', '10485760', 'Maximum file upload size in bytes (10MB)'),
('allowed_file_types', 'pdf,doc,docx,jpg,jpeg,png', 'Allowed file types for uploads'),
('email_verification_required', 'false', 'Whether email verification is required for registration'),
('admin_email', 'admin@monaha.edu', 'Administrator email address');

-- Insert sample admin user (password: admin123)
INSERT INTO users (name, email, password_hash, role) VALUES
('Administrator', 'admin@monaha.edu', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj3bp.Gm.F5e', 'admin');

-- Insert sample student user (password: 12345)
INSERT INTO users (name, email, password_hash, role) VALUES
('Ali Ahmed', 'ali@example.com', '$2b$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'student');

-- Insert sample scholarships
INSERT INTO scholarships (name, description, country, program, funding, deadline, requirements) VALUES
('Harvard Merit Scholarship', 'Full scholarship for outstanding students at Harvard University', 'us', 'bachelor', 'full', '2024-12-31', 'GPA 3.8+, SAT 1500+, Leadership experience'),
('Oxford Rhodes Scholarship', 'Prestigious scholarship for international students at Oxford', 'uk', 'master', 'full', '2024-10-15', 'Bachelor degree with honors, Leadership potential, Academic excellence'),
('University of Toronto Excellence Award', 'Partial funding for Canadian and international students', 'ca', 'bachelor', 'partial', '2024-11-30', 'GPA 3.5+, Community involvement, Financial need'),
('Australian National University PhD Fellowship', 'Full funding for PhD research students', 'au', 'phd', 'full', '2024-09-30', 'Master degree, Research proposal, Academic references'),
('DAAD German Academic Exchange', 'Scholarship for international students in Germany', 'de', 'master', 'partial', '2024-08-31', 'Bachelor degree, German language proficiency, Academic merit');

-- Insert sample universities
INSERT INTO universities (name, location, country, ranking, acceptance_rate, student_count, tuition, tuition_range, website_url, description) VALUES
('Harvard University', 'Cambridge, Massachusetts', 'us', 1, '5%', '23,000', '$54,000/year', 'high', 'https://harvard.edu', 'Harvard University is a private Ivy League research university in Cambridge, Massachusetts.'),
('University of Oxford', 'Oxford, England', 'uk', 2, '17%', '24,000', '£9,250/year', 'medium', 'https://ox.ac.uk', 'The University of Oxford is a collegiate research university in Oxford, England.'),
('University of Toronto', 'Toronto, Ontario', 'ca', 25, '43%', '97,000', 'CAD $58,000/year', 'high', 'https://utoronto.ca', 'The University of Toronto is a public research university in Toronto, Ontario, Canada.'),
('Australian National University', 'Canberra, ACT', 'au', 31, '35%', '25,000', 'AUD $45,000/year', 'high', 'https://anu.edu.au', 'The Australian National University is a public research university located in Canberra.'),
('Technical University of Munich', 'Munich, Bavaria', 'de', 50, '8%', '45,000', '€150/semester', 'free', 'https://tum.de', 'The Technical University of Munich is a public research university in Munich, Germany.'),
('Sorbonne University', 'Paris, France', 'fr', 72, '25%', '55,000', '€170/year', 'free', 'https://sorbonne-universite.fr', 'Sorbonne University is a public research university in Paris, France.'),
('University of Amsterdam', 'Amsterdam, Netherlands', 'nl', 58, '30%', '42,000', '€2,314/year', 'low', 'https://uva.nl', 'The University of Amsterdam is a public research university located in Amsterdam, Netherlands.'),
('KTH Royal Institute of Technology', 'Stockholm, Sweden', 'se', 89, '40%', '18,000', 'Free for EU, SEK 145,000/year for non-EU', 'medium', 'https://kth.se', 'KTH Royal Institute of Technology is a public research university in Stockholm, Sweden.');

-- Insert sample university programs
INSERT INTO university_programs (university_id, name, level, duration, field_of_study, description, requirements, tuition, application_deadline, start_date) VALUES
(1, 'Computer Science', 'bachelor', '4 years', 'computer-science', 'Comprehensive computer science program', 'High school diploma, SAT scores', '$54,000/year', '2024-12-31', '2025-09-01'),
(1, 'MBA', 'master', '2 years', 'business', 'Master of Business Administration', 'Bachelor degree, GMAT scores', '$73,440/year', '2024-12-31', '2025-09-01'),
(2, 'Philosophy, Politics and Economics', 'bachelor', '3 years', 'social-sciences', 'Interdisciplinary program combining three fields', 'A-levels, personal statement', '£9,250/year', '2024-10-15', '2025-10-01'),
(2, 'DPhil in Computer Science', 'phd', '3-4 years', 'computer-science', 'Research doctorate in computer science', 'Master degree, research proposal', '£4,407/year', '2024-10-15', '2025-10-01'),
(3, 'Engineering Science', 'bachelor', '4 years', 'engineering', 'Broad-based engineering program', 'High school diploma, strong math/science', 'CAD $58,000/year', '2024-11-30', '2025-09-01'),
(3, 'Master of Information', 'master', '2 years', 'computer-science', 'Information studies and technology', 'Bachelor degree, relevant experience', 'CAD $25,000/year', '2024-11-30', '2025-09-01'),
(4, 'Bachelor of Science', 'bachelor', '3 years', 'sciences', 'Flexible science degree program', 'High school completion, ATAR score', 'AUD $45,000/year', '2024-09-30', '2025-02-01'),
(4, 'PhD in Physics', 'phd', '3-4 years', 'sciences', 'Research doctorate in physics', 'Honours degree in physics', 'AUD $28,854/year', '2024-09-30', '2025-02-01'),
(5, 'Mechanical Engineering', 'bachelor', '3 years', 'engineering', 'Traditional mechanical engineering program', 'Abitur or equivalent', '€150/semester', '2024-08-31', '2025-10-01'),
(5, 'Data Engineering and Analytics', 'master', '2 years', 'computer-science', 'Advanced data science program', 'Bachelor in relevant field', '€150/semester', '2024-08-31', '2025-10-01');

-- Insert sample university offers
INSERT INTO university_offers (university_id, type, name, description, amount, deadline, requirements, eligibility_criteria) VALUES
(1, 'scholarship', 'Harvard Merit Scholarship', 'Full tuition scholarship for outstanding students', 'Full Tuition', '2024-12-31', 'GPA 3.8+, SAT 1500+, Leadership experience', 'International and domestic students'),
(2, 'scholarship', 'Rhodes Scholarship', 'Prestigious scholarship for international students', 'Full Funding', '2024-10-15', 'Bachelor degree with honors, Leadership potential', 'International students only'),
(3, 'scholarship', 'Lester B. Pearson Scholarship', 'Full scholarship including living expenses', 'Full Tuition + Living', '2024-11-30', 'Academic excellence, leadership, community involvement', 'International students'),
(4, 'scholarship', 'ANU Chancellor\'s International Scholarship', 'Partial tuition scholarship', '25% Tuition', '2024-09-30', 'Academic merit, English proficiency', 'International students'),
(5, 'scholarship', 'DAAD Scholarship', 'Monthly stipend for living expenses', '€850/month', '2024-08-31', 'Academic excellence, German language skills preferred', 'International students'),
(6, 'scholarship', 'Eiffel Excellence Scholarship', 'Monthly allowance for master and PhD students', '€1,181/month', '2024-07-15', 'Academic excellence, research potential', 'International students'),
(7, 'scholarship', 'Amsterdam Merit Scholarship', 'One-time scholarship for excellent students', '€25,000', '2024-06-30', 'Academic merit, motivation letter', 'Non-EU students'),
(8, 'scholarship', 'KTH Scholarship', 'Full tuition waiver for non-EU students', 'Full Tuition', '2024-05-31', 'Academic excellence, English proficiency', 'Non-EU students');

-- Insert sample university fields
INSERT INTO university_fields (university_id, field_name, department) VALUES
(1, 'business', 'Harvard Business School'),
(1, 'law', 'Harvard Law School'),
(1, 'medicine', 'Harvard Medical School'),
(1, 'engineering', 'School of Engineering and Applied Sciences'),
(1, 'arts', 'Faculty of Arts and Sciences'),
(2, 'arts', 'Humanities Division'),
(2, 'sciences', 'Mathematical, Physical and Life Sciences'),
(2, 'law', 'Faculty of Law'),
(2, 'medicine', 'Medical Sciences Division'),
(2, 'business', 'Saïd Business School'),
(3, 'engineering', 'Faculty of Applied Science & Engineering'),
(3, 'computer-science', 'Department of Computer Science'),
(3, 'medicine', 'Faculty of Medicine'),
(3, 'business', 'Rotman School of Management'),
(3, 'sciences', 'Faculty of Arts & Science'),
(4, 'sciences', 'College of Science'),
(4, 'engineering', 'College of Engineering & Computer Science'),
(4, 'social-sciences', 'College of Arts & Social Sciences'),
(4, 'arts', 'School of Art & Design'),
(4, 'law', 'ANU College of Law'),
(5, 'engineering', 'School of Engineering and Design'),
(5, 'computer-science', 'Department of Informatics'),
(5, 'sciences', 'School of Natural Sciences'),
(5, 'business', 'TUM School of Management');

-- Insert sample forum posts
INSERT INTO forum_posts (user_id, author_name, title, content, category, likes) VALUES
(2, 'Ali Ahmed', 'Tips for scholarship applications', 'Here are some tips I learned while applying for scholarships...', 'scholarships', 5),
(2, 'Ali Ahmed', 'My experience with motivation letters', 'Writing a compelling motivation letter can be challenging...', 'help', 3);

