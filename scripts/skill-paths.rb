# frozen_string_literal: true

SKILLS_ROOT = "skills"

def skill_storage_group(entry)
  entry.fetch("division", entry.fetch("collection", "agency"))
end

def skill_storage_path(entry)
  entry["path"] || File.join(SKILLS_ROOT, skill_storage_group(entry), entry.fetch("skill"))
end

def skill_path_for(group, skill)
  File.join(SKILLS_ROOT, group, skill)
end
